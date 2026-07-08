library auth_footer_link;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

/// Deep red for auth screen footer links (Create account / Sign in).
const authFooterLinkColor = Color(0xFF800517);

/// Spacing between primary button and footer link (~½ of [S.md]).
const authFooterLinkTopGap = S.sm;

const double _footerLinkFontSize = 13;
const double _underlineThickness = 1.25;
const double _underlineGap = 2;

TextStyle authFooterLinkStyle() => GoogleFonts.inter(
      fontSize: _footerLinkFontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.3,
      color: authFooterLinkColor,
      decoration: TextDecoration.none,
    );

/// Compact footer link with an underline on mouse hover (and press).
class AuthFooterLink extends StatefulWidget {
  const AuthFooterLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<AuthFooterLink> createState() => _AuthFooterLinkState();
}

class _AuthFooterLinkState extends State<AuthFooterLink> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _showUnderline => _hovered || _pressed;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onHover: (_) => _setHovered(true),
        onExit: (_) {
          _setHovered(false);
          _setPressed(false);
        },
        child: Listener(
          onPointerHover: (_) => _setHovered(true),
          child: GestureDetector(
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) {
              _setPressed(false);
              widget.onPressed();
            },
            onTapCancel: () => _setPressed(false),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: S.xs,
                horizontal: S.sm,
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: authFooterLinkStyle(),
                    ),
                    const SizedBox(height: _underlineGap),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      height: _underlineThickness,
                      color: _showUnderline
                          ? authFooterLinkColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
