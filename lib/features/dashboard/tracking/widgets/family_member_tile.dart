library family_member_tile;

import 'package:flutter/material.dart';
import 'package:suraksha/models/contact_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

/// Horizontal / vertical gap between guardian cards in the masonry grid.
const double kGuardianGridGap = S.sm;

class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({super.key, required this.member});

  final ContactModel member;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(S.md),
        decoration: BoxDecoration(
          color: dashboardCard,
          borderRadius: BorderRadius.circular(S.radiusLg),
          border: Border.all(color: dashboardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: surakshaSecondary,
                  backgroundImage: member.avatarPath != null
                      ? AssetImage(member.avatarPath!)
                      : null,
                  child: member.avatarPath == null
                      ? Text(
                          member.initials,
                          style: SurakshaTypography.dashTitle.copyWith(
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
                const Spacer(),
                const Icon(
                  Icons.phone_outlined,
                  color: surakshaMuted,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: S.sm),
            Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SurakshaTypography.dashTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: S.xs),
            Text(
              member.role,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SurakshaTypography.monoLabel.copyWith(
                color: surakshaCrimson,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: S.xs),
            Text(
              member.phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: SurakshaTypography.monoLabel.copyWith(fontSize: 11),
            ),
          ],
        ),
      );
}
