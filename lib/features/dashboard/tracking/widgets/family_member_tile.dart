library family_member_tile;

import 'package:flutter/material.dart';
import 'package:suraksha/models/contact_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class FamilyMemberTile extends StatelessWidget {
  const FamilyMemberTile({super.key, required this.member});

  final ContactModel member;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: S.sm),
        padding: const EdgeInsets.symmetric(horizontal: S.md, vertical: S.md),
        decoration: BoxDecoration(
          color: dashboardCard,
          borderRadius: BorderRadius.circular(S.radiusLg),
          border: Border.all(color: dashboardBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: surakshaSecondary,
              backgroundImage: member.avatarPath != null
                  ? AssetImage(member.avatarPath!)
                  : null,
              child: member.avatarPath == null
                  ? Text(
                      member.initials,
                      style: SurakshaTypography.dashTitle.copyWith(
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: S.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: SurakshaTypography.dashTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.role,
                    style: SurakshaTypography.monoLabel.copyWith(
                      color: surakshaCrimson,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.phone_outlined, color: surakshaMuted, size: 18),
                const SizedBox(height: 4),
                Text(
                  member.phone,
                  style: SurakshaTypography.monoLabel.copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      );
}
