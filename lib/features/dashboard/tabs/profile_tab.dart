library profile_tab;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/auth/auth_provider.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/router/app_routes.dart';
import 'package:suraksha/services/ble_service.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final dash = ref.watch(dashboardProvider);
    final user = auth.user;
    final bottomPad = S.bottomNavHeight + MediaQuery.paddingOf(context).bottom;
    final family = ref.watch(familyMembersProvider);

    return ColoredBox(
      color: dashboardBg,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(S.lg, S.lg, S.lg, bottomPad + S.lg),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: surakshaCrimson,
                    child: Text(
                      user?.name.substring(0, 2).toUpperCase() ?? 'PS',
                      style: SurakshaTypography.dashGreeting,
                    ),
                  ),
                  const SizedBox(height: S.md),
                  Text(
                    user?.name ?? 'Priya Sharma',
                    style: SurakshaTypography.dashGreeting,
                  ),
                  Text(
                    user?.email ?? user?.phone ?? '+91 98765 43210',
                    style: SurakshaTypography.monoLabel,
                  ),
                ],
              ),
            ),
            const SizedBox(height: S.xl),
            _Section(CopyConstants.familyMembersTitle, [
              ...family.map(
                (c) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: c.avatarPath != null
                        ? AssetImage(c.avatarPath!)
                        : null,
                    child: c.avatarPath == null ? Text(c.initials) : null,
                  ),
                  title: Text(c.name),
                  subtitle: Text('${c.role} · ${c.phone}'),
                ),
              ),
            ]),
            _Section('Location', [
              SwitchListTile(
                title: const Text('Share my location'),
                subtitle: const Text(
                  'Used for SOS alerts to the police dashboard',
                ),
                value: dash.locationSharingActive,
                activeThumbColor: surakshaCrimson,
                onChanged: (_) =>
                    ref.read(dashboardProvider.notifier).toggleLocationSharing(),
              ),
            ]),
            _Section('Device', [
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
              ListTile(
                title: const Text('Band status'),
                trailing: Text(
                  dash.bandConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color:
                        dash.bandConnected ? surakshaSuccess : surakshaMuted,
                  ),
                ),
              ),
            ]),
            _Section('Notifications', [
              SwitchListTile(
                title: const Text('SOS alerts'),
                value: true,
                activeThumbColor: surakshaCrimson,
                onChanged: (_) {},
              ),
            ]),
            _Section('Account', [
              ListTile(
                title: const Text('Marketing site'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.home),
              ),
              ListTile(
                title: const Text('Support'),
                onTap: () {},
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
