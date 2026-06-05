library tracking_tab;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/dark_map_widget.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/family_header_bar.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/family_member_tile.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/map_location_sharing_banner.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';
import 'package:suraksha/widgets/animations/stagger_list_animator.dart';

class TrackingTab extends ConsumerStatefulWidget {
  const TrackingTab({super.key});

  @override
  ConsumerState<TrackingTab> createState() => _TrackingTabState();
}

class _TrackingTabState extends ConsumerState<TrackingTab> {
  bool _mapExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dash = ref.watch(dashboardProvider);
    final family = ref.watch(familyMembersProvider);
    final bottomPad = S.bottomNavHeight + MediaQuery.paddingOf(context).bottom;

    return ColoredBox(
      color: dashboardBg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FamilyHeaderBar(unreadCount: dash.unreadNotifications),
            Stack(
              clipBehavior: Clip.none,
              children: [
                DarkMapWidget(
                  expanded: _mapExpanded,
                  onToggle: () => setState(() => _mapExpanded = !_mapExpanded),
                ),
                Positioned(
                  left: S.lg,
                  right: S.lg,
                  bottom: -20,
                  child: MapLocationSharingBanner(
                    active: dash.locationSharingActive,
                    onToggle: (_) => ref
                        .read(dashboardProvider.notifier)
                        .toggleLocationSharing(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: S.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CopyConstants.familyMembersTitle,
                    style: SurakshaTypography.dashGreeting.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: S.xs),
                  Text(
                    CopyConstants.familyMembersSubtitle,
                    style: SurakshaTypography.dashSubtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: S.sm),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(S.md, S.sm, S.md, bottomPad),
                children: [
                  StaggerListAnimator(
                    itemCount: family.length,
                    itemBuilder: (context, i, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(anim),
                        child: FamilyMemberTile(member: family[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
