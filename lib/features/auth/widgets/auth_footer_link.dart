library auth_footer_link;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/features/auth/widgets/auth_underline_field_style.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

/// Accessible auth footer link color — aliases [surakshaAuthLink].
const authFooterLinkColor = surakshaAuthLink;

/// Spacing between primary button and footer link (~½ of [S.md]).
const authFooterLinkTopGap = S.sm;

const double _footerLinkFontSize = 13;
const double _hoverUnderlineThickness = 1.25;
const double _hoverUnderlineGap = 2;
const Duration _hoverUnderlineDuration = Duration(milliseconds: 120);

TextStyle authFooterLinkStyle() => GoogleFonts.inter(
      fontSize: _footerLinkFontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.3,
      color: authFooterLinkColor,
      decoration: TextDecoration.none,
    );

/// Compact footer link with an underline on mouse hover (and press).
///
/// When [revealUnderlineOnMount] is true, draws a one-shot left-to-right
/// crimson underline reveal on first mount, then keeps it static. Hover
/// underline is skipped in that mode.
class AuthFooterLink extends StatefulWidget {
  const AuthFooterLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.revealUnderlineOnMount = false,
  });

  final String label;
  final VoidCallback onPressed;

  /// One-shot L→R width reveal (Create account on Sign In). Default off so
  /// Signup / Guardian links keep hover-only underlines.
  final bool revealUnderlineOnMount;

  @override
  State<AuthFooterLink> createState() => _AuthFooterLinkState();
}

class _AuthFooterLinkState extends State<AuthFooterLink>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  AnimationController? _revealController;
  bool _revealStarted = false;

  bool get _showHoverUnderline =>
      !widget.revealUnderlineOnMount && (_hovered || _pressed);

  double get _labelWidth {
    final painter = TextPainter(
      text: TextSpan(text: widget.label, style: authFooterLinkStyle()),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  @override
  void initState() {
    super.initState();
    if (widget.revealUnderlineOnMount) {
      _revealController = AnimationController(
        vsync: this,
        duration: kRegisterUnderlineDuration,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _revealController;
    if (controller == null || _revealStarted) return;
    _revealStarted = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      controller.value = 1.0;
    } else {
      controller.forward();
    }
  }

  @override
  void dispose() {
    _revealController?.dispose();
    super.dispose();
  }

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  Widget _buildRevealUnderline(double labelWidth) {
    final reveal = _revealController!;
    return AnimatedBuilder(
      animation: reveal,
      builder: (context, _) {
        final t = kRegisterUnderlineCurve.transform(reveal.value);
        return SizedBox(
          width: labelWidth,
          height: kRegisterUnderlineThickness,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: labelWidth * t,
              height: kRegisterUnderlineThickness,
              child: const ColoredBox(color: kFieldUnderlineFocused),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoverUnderline(double labelWidth) {
    return SizedBox(
      width: labelWidth,
      child: AnimatedContainer(
        duration: _hoverUnderlineDuration,
        curve: Curves.easeOut,
        height: _hoverUnderlineThickness,
        color: _showHoverUnderline ? authFooterLinkColor : Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelWidth = _labelWidth;
    final reveal = widget.revealUnderlineOnMount;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          onHover: _setHovered,
          onHighlightChanged: _setPressed,
          overlayColor: const WidgetStatePropertyAll(surakshaAuthLinkSplash),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: S.xs,
              horizontal: S.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: authFooterLinkStyle(),
                ),
                SizedBox(
                  height: reveal ? kRegisterUnderlineGap : _hoverUnderlineGap,
                ),
                if (reveal)
                  _buildRevealUnderline(labelWidth)
                else
                  _buildHoverUnderline(labelWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
