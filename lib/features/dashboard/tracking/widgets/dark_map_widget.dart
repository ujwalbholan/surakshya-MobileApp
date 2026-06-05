library dark_map_widget;

import 'package:flutter/material.dart';
import 'package:suraksha/features/dashboard/tracking/tracking_map_view.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

class DarkMapWidget extends StatelessWidget {
  const DarkMapWidget({
    super.key,
    required this.expanded,
    required this.onToggle,
  });

  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOut,
          height: expanded ? 320 : 140,
          margin: const EdgeInsets.symmetric(horizontal: S.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(S.radiusLg),
            border: Border.all(color: dashboardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const TrackingMapView(),
              Positioned(
                right: S.sm,
                top: S.sm,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: surakshaBlack.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: surakshaForeground,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
