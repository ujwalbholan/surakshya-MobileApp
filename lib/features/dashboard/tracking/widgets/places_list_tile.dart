library places_list_tile;

import 'package:flutter/material.dart';
import 'package:suraksha/models/location_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class PlacesListTile extends StatelessWidget {
  const PlacesListTile({super.key, required this.place});

  final PlaceModel place;

  IconData get _icon {
    switch (place.type) {
      case 'work':
        return Icons.work_outline;
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.home_outlined;
    }
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: surakshaSecondary,
                borderRadius: BorderRadius.circular(S.radius),
              ),
              child: Icon(_icon, color: surakshaYellow),
            ),
            const SizedBox(width: S.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: SurakshaTypography.dashTitle),
                  Text(
                    place.location.label,
                    style: SurakshaTypography.dashSubtitle,
                  ),
                ],
              ),
            ),
            Text(
              '${place.memberCount} member${place.memberCount == 1 ? '' : 's'}',
              style: SurakshaTypography.monoLabel,
            ),
          ],
        ),
      );
}
