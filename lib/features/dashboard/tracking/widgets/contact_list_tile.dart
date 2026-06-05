library contact_list_tile;

import 'package:flutter/material.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/battery_indicator.dart';
import 'package:suraksha/models/contact_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contact,
    required this.onTap,
  });

  final ContactModel contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(S.radiusLg),
        child: Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: S.sm),
          padding: const EdgeInsets.symmetric(horizontal: S.md),
          decoration: BoxDecoration(
            color: dashboardCard,
            borderRadius: BorderRadius.circular(S.radiusLg),
            border: Border.all(color: dashboardBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: contact.id == 'me'
                    ? dashboardActiveDot
                    : surakshaSecondary,
                backgroundImage: contact.avatarPath != null
                    ? AssetImage(contact.avatarPath!)
                    : null,
                child: contact.avatarPath == null
                    ? Text(
                        contact.initials,
                        style: SurakshaTypography.dashTitle.copyWith(
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: S.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: SurakshaTypography.dashTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${contact.placeEmoji} ${contact.placeLabel} · ${contact.lastSeen}',
                      style: SurakshaTypography.dashSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              BatteryIndicator(percent: contact.batteryPercent),
              const SizedBox(width: 6),
              Text(
                '${contact.batteryPercent}%',
                style: SurakshaTypography.monoLabel.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      );
}
