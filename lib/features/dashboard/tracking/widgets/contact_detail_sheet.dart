library contact_detail_sheet;

import 'package:flutter/material.dart';
import 'package:suraksha/models/contact_model.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailSheet extends StatelessWidget {
  const ContactDetailSheet({super.key, required this.contact});

  final ContactModel contact;

  static Future<void> show(BuildContext context, ContactModel contact) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: dashboardSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(S.radiusXl)),
      ),
      builder: (_) => ContactDetailSheet(contact: contact),
    );
  }

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(S.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: contact.avatarPath != null
                  ? AssetImage(contact.avatarPath!)
                  : null,
              backgroundColor: surakshaSecondary,
              child: contact.avatarPath == null
                  ? Text(contact.initials, style: SurakshaTypography.dashTitle)
                  : null,
            ),
            const SizedBox(height: S.md),
            Text(contact.name, style: SurakshaTypography.dashGreeting),
            Text(
              '${contact.placeEmoji} ${contact.placeLabel} · ${contact.lastSeen}',
              style: SurakshaTypography.dashSubtitle,
            ),
            const SizedBox(height: S.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  onTap: () => _launch(Uri(scheme: 'tel', path: contact.phone)),
                ),
                _ActionButton(
                  icon: Icons.message_outlined,
                  label: 'Message',
                  onTap: () => _launch(Uri(scheme: 'sms', path: contact.phone)),
                ),
                _ActionButton(
                  icon: Icons.map_outlined,
                  label: 'Map',
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + S.md),
          ],
        ),
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(S.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(S.md),
          child: Column(
            children: [
              Icon(icon, color: surakshaCrimson, size: 28),
              const SizedBox(height: S.xs),
              Text(label, style: SurakshaTypography.monoLabel),
            ],
          ),
        ),
      );
}
