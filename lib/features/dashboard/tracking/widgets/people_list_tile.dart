library people_list_tile;

import 'package:flutter/material.dart';
import 'package:suraksha/models/contact_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class PeopleListTile extends StatelessWidget {
  const PeopleListTile({super.key, required this.contact});

  final ContactModel contact;

  IconData _placeIcon(PlaceType type) {
    switch (type) {
      case PlaceType.home:
        return Icons.home_outlined;
      case PlaceType.work:
        return Icons.work_outline;
      case PlaceType.school:
        return Icons.school_outlined;
      case PlaceType.preschool:
        return Icons.child_care_outlined;
      case PlaceType.other:
        return Icons.place_outlined;
    }
  }

  Color _batteryColor(int percent) {
    if (percent <= 20) return surakshaDanger;
    if (percent <= 50) return surakshaWarning;
    return dashboardActiveDot;
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: S.sm),
        padding: const EdgeInsets.all(S.md),
        decoration: BoxDecoration(
          color: dashboardCard,
          borderRadius: BorderRadius.circular(S.radiusLg),
          border: Border.all(color: dashboardBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: contact.id == 'me'
                  ? dashboardActiveDot
                  : surakshaSecondary,
              backgroundImage: contact.avatarPath != null
                  ? AssetImage(contact.avatarPath!)
                  : null,
              child: contact.avatarPath == null
                  ? Text(
                      contact.initials,
                      style: SurakshaTypography.dashSubtitle.copyWith(
                        color: surakshaForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: S.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        contact.name,
                        style: SurakshaTypography.dashTitle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: S.sm),
                      Icon(
                        Icons.battery_std,
                        size: 14,
                        color: _batteryColor(contact.batteryPercent),
                      ),
                      Text(
                        '${contact.batteryPercent}%',
                        style: SurakshaTypography.monoLabel.copyWith(
                          color: _batteryColor(contact.batteryPercent),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _placeIcon(contact.placeType),
                        size: 14,
                        color: surakshaMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${contact.placeLabel} · ${contact.lastSeen}',
                        style: SurakshaTypography.dashSubtitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (contact.distanceKm > 0)
              Text(
                '${contact.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
                style: SurakshaTypography.dashSubtitle,
              ),
          ],
        ),
      );
}
