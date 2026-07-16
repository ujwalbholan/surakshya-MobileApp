library family_header_bar;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class FamilyHeaderBar extends ConsumerWidget {
  const FamilyHeaderBar({super.key, required this.unreadCount});

  final int unreadCount;

  void _openNotificationsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: dashboardSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(S.radiusXl)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          S.lg,
          S.lg,
          S.lg,
          S.lg + MediaQuery.paddingOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: dashboardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: S.lg),
            Text(
              CopyConstants.notificationsTitle,
              style: SurakshaTypography.dashTitle,
            ),
            const SizedBox(height: S.sm),
            Text(
              CopyConstants.notificationsEmpty,
              style: SurakshaTypography.dashSubtitle.copyWith(
                color: surakshaAuthText,
              ),
            ),
            const SizedBox(height: S.lg),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: surakshaCrimson),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: S.md, vertical: S.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label: 'Settings',
              button: true,
              child: IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: surakshaForeground,
                ),
                onPressed: () => ref
                    .read(dashboardProvider.notifier)
                    .setTab(DashboardTab.profile),
              ),
            ),
            Semantics(
              label: 'Notifications',
              button: true,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: surakshaForeground,
                    ),
                    onPressed: () => _openNotificationsSheet(context),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: surakshaYellow,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
