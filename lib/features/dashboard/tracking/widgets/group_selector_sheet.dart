library group_selector_sheet;

import 'package:flutter/material.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

const _mockGroups = ['My family', 'Close friends', 'Work circle'];

class GroupSelectorSheet extends StatelessWidget {
  const GroupSelectorSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static Future<void> show(
    BuildContext context, {
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: dashboardSheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(S.radiusXl)),
      ),
      builder: (_) => GroupSelectorSheet(
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: S.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select circle', style: SurakshaTypography.dashTitle),
            const SizedBox(height: S.md),
            ..._mockGroups.map(
              (g) => ListTile(
                title: Text(g),
                trailing: g == selected
                    ? const Icon(Icons.check, color: surakshaCrimson)
                    : null,
                onTap: () {
                  onSelected(g);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );
}
