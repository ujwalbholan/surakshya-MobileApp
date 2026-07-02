library suraksha_label;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_colors.dart';

/// Shadcn-style form label for auth screens.
class SurakshaLabel extends StatelessWidget {
  const SurakshaLabel({super.key, required this.text});

  final String text;

  static final TextStyle _style = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.14,
    color: surakshaAuthText,
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: Text(text, style: _style),
    );
  }
}
