library parent_home_tab;

import 'package:flutter/material.dart';
import 'package:suraksha/features/parent/parent_dashboard_screen.dart';

/// Home tab body for the parent dashboard shell.
///
/// Content will be inlined here in a follow-up; for now delegates to the
/// existing dashboard screen.
class ParentHomeTab extends StatelessWidget {
  const ParentHomeTab({super.key});

  @override
  Widget build(BuildContext context) => const ParentDashboardScreen();
}
