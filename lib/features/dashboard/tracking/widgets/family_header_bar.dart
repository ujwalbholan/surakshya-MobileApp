library family_header_bar;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/router/app_routes.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

class FamilyHeaderBar extends ConsumerWidget {
  const FamilyHeaderBar({super.key, required this.unreadCount});

  final int unreadCount;

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
                    onPressed: () => context.push(AppRoutes.notifications),
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
