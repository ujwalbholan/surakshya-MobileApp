library profile_tab;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/auth/auth_provider.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/features/dashboard/profile/widgets/profile_hero_card.dart';
import 'package:suraksha/features/guardians/edit_guardian_phone_sheet.dart';
import 'package:suraksha/features/guardians/guardian_provider.dart';
import 'package:suraksha/router/app_routes.dart';
import 'package:suraksha/services/ble_service.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider).isLoggedIn) {
        ref.read(guardianLinkingProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final dash = ref.watch(dashboardProvider);
    final guardians = ref.watch(guardianLinkingProvider);
    final user = auth.user;
    final bottomPad = S.bottomNavHeight + MediaQuery.paddingOf(context).bottom;

    return Material(
      color: dashboardBg,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(S.lg, S.lg, S.lg, bottomPad + S.lg),
          children: [
            // Phase 1: hero only — sections unchanged until Phase 2 approval.
            ProfileHeroCard(user: user),
            const SizedBox(height: S.xl),
            _Section(CopyConstants.familyMembersTitle, [
              Material(
                color: dashboardCard,
                borderRadius: BorderRadius.circular(S.radiusLg),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(CopyConstants.manageGuardians),
                      subtitle: Text(
                        guardians.guardians.isEmpty
                            ? CopyConstants.noLinkedGuardians
                            : '${guardians.guardians.length} linked · ${guardians.pendingRequests.length} pending',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.guardians),
                    ),
                    const Divider(height: 1, color: dashboardBorder),
                    ListTile(
                      title: const Text(CopyConstants.emergencyContactTitle),
                      subtitle: Text(
                        () {
                          final matches = guardians.guardians
                              .where((g) => g.isEmergencyContact);
                          if (matches.isEmpty) {
                            return CopyConstants.noEmergencyContactYet;
                          }
                          final emergency = matches.first;
                          return '${emergency.fullName} · ${emergency.phone}';
                        }(),
                      ),
                      trailing: const Icon(Icons.star_rounded,
                          color: surakshaCrimson),
                      onTap: () {
                        final matches = guardians.guardians
                            .where((g) => g.isEmergencyContact);
                        if (matches.isEmpty) {
                          context.push(AppRoutes.guardians);
                          return;
                        }
                        showEditGuardianPhoneSheet(
                          context: context,
                          ref: ref,
                          guardian: matches.first,
                        );
                      },
                    ),
                    if (guardians.guardians.isEmpty && !guardians.loading)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          S.md,
                          0,
                          S.md,
                          S.sm,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            CopyConstants.noLinkedGuardians,
                            style: SurakshaTypography.monoLabel,
                          ),
                        ),
                      )
                    else
                      ...guardians.guardians.map(
                        (g) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                surakshaCrimson.withValues(alpha: 0.15),
                            child: Text(
                              g.initials,
                              style: const TextStyle(color: surakshaCrimson),
                            ),
                          ),
                          title: Text(g.fullName),
                          subtitle: Text(
                            g.isEmergencyContact
                                ? '${CopyConstants.emergencyContactBadge} · ${g.phone}'
                                : 'Guardian · ${g.phone}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (g.isEmergencyContact)
                                const Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: surakshaCrimson,
                                    size: 20,
                                  ),
                                ),
                              IconButton(
                                tooltip: CopyConstants.editPhoneAction,
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                color: surakshaMuted,
                                onPressed: () => showEditGuardianPhoneSheet(
                                  context: context,
                                  ref: ref,
                                  guardian: g,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => showEditGuardianPhoneSheet(
                            context: context,
                            ref: ref,
                            guardian: g,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ]),
            _Section('Location', [
              _settingsCard(
                SwitchListTile(
                  title: const Text('Share my location'),
                  subtitle: const Text(
                    'Used for SOS alerts to the police dashboard',
                  ),
                  value: dash.locationSharingActive,
                  activeThumbColor: surakshaCrimson,
                  onChanged: (_) => ref
                      .read(dashboardProvider.notifier)
                      .toggleLocationSharing(),
                ),
              ),
            ]),
            _Section('Device', [
              _settingsCard(
                Column(
                  children: [
                    ListTile(
                      title: const Text('Pair Suraksha Band'),
                      trailing: const Icon(Icons.bluetooth),
                      onTap: () async {
                        await ref.read(bleServiceProvider).startScan();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('BLE scan started')),
                          );
                        }
                      },
                    ),
                    const Divider(height: 1, color: dashboardBorder),
                    ListTile(
                      title: const Text('Band status'),
                      trailing: Text(
                        dash.bandConnected ? 'Connected' : 'Disconnected',
                        style: TextStyle(
                          color: dash.bandConnected
                              ? surakshaSuccess
                              : surakshaMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            _Section('Notifications', [
              _settingsCard(
                SwitchListTile(
                  title: const Text('SOS alerts'),
                  value: true,
                  activeThumbColor: surakshaCrimson,
                  onChanged: (_) {},
                ),
              ),
            ]),
            _Section('Account', [
              _settingsCard(
                Column(
                  children: [
                    ListTile(
                      title: const Text('Marketing site'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.home),
                    ),
                    const Divider(height: 1, color: dashboardBorder),
                    ListTile(
                      title: const Text('Support'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ]),
            Center(
              child: TextButton(
                onPressed: () => _confirmSignOut(context, ref),
                child: const Text(
                  CopyConstants.profileSignOut,
                  style: TextStyle(color: surakshaCrimson),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: dashboardSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(S.radiusXl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(S.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CopyConstants.profileSignOut,
              style: SurakshaTypography.dashTitle,
            ),
            const SizedBox(height: S.sm),
            const Text(CopyConstants.profileSignOutConfirm),
            const SizedBox(height: S.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: S.md),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: surakshaCrimson,
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (confirm == true) {
      ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go(AppRoutes.login);
    }
  }
}

Widget _settingsCard(Widget child) => Material(
      color: dashboardCard,
      borderRadius: BorderRadius.circular(S.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: SurakshaTypography.monoLabel),
          const SizedBox(height: S.sm),
          ...children,
          const SizedBox(height: S.lg),
        ],
      );
}
