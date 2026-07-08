library auth_field_decoration;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

/// Deep red for auth screen footer links (Create account / Sign in).
const authFooterLinkColor = Color(0xFF800517);

TextStyle authFooterLinkStyle() => GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.35,
      color: authFooterLinkColor,
    );

ButtonStyle authFooterLinkButtonStyle() => TextButton.styleFrom(
      foregroundColor: authFooterLinkColor,
      padding: const EdgeInsets.symmetric(
        vertical: S.md,
        horizontal: S.lg,
      ),
      textStyle: authFooterLinkStyle(),
    );

/// Matches [SurakshaEmailInput] — solid card fill, not the theme's translucent default.
InputDecoration authFieldDecoration({
  required String labelText,
  String? hintText,
  Widget? suffixIcon,
}) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(S.radius),
    borderSide: const BorderSide(color: surakshaBorder),
  );

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: surakshaCard,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(S.radius),
      borderSide: const BorderSide(color: surakshaAuthFocus, width: 1.5),
    ),
  );
}
