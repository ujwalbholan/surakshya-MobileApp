library origin_button;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_animations.dart';
import 'package:suraksha/theme/suraksha_colors.dart';

/// Auth primary button with a radial fill that originates from the pointer
/// or keyboard focus point.
class OriginButton extends StatefulWidget {
  const OriginButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.loading = false,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool loading;
  final bool enabled;

  @override
  State<OriginButton> createState() => _OriginButtonState();
}

class _OriginButtonState extends State<OriginButton>
    with SingleTickerProviderStateMixin {
  static const _height = 48.0;
  static const _radius = 12.0;
  static const _horizontalPadding = 32.0;
  static const _tapScale = 0.985;
  static const _fillDuration = Duration(milliseconds: 500);
  static const _tapDuration = Duration(milliseconds: 150);

  static final TextStyle _labelStyle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  late final AnimationController _fillController;
  late final Animation<double> _fillAnimation;
  late final FocusNode _focusNode;

  double _originX = 0;
  double _originY = 0;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasFocus = false;

  bool get _isInactive => !widget.enabled || widget.loading;

  bool get _showFill =>
      !_isInactive && (_isHovered || _isPressed || _hasFocus);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _fillController = AnimationController(
      vsync: this,
      duration: _fillDuration,
    );
    _fillAnimation = CurvedAnimation(
      parent: _fillController,
      curve: SurakshaAnimations.easeOutExpo,
      reverseCurve: SurakshaAnimations.easeOutExpo.flipped,
    );
  }

  @override
  void didUpdateWidget(covariant OriginButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInactive) {
      if (_isPressed) _setPressed(false);
      if (_isHovered) _setHovered(false);
    } else {
      _syncFillAnimation();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _fillController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused == _hasFocus) return;
    setState(() => _hasFocus = focused);
    if (focused) {
      _setOriginToCenter();
    }
    _syncFillAnimation();
  }

  void _syncFillAnimation() {
    if (_showFill) {
      _fillController.forward();
    } else {
      _fillController.reverse();
    }
  }

  void _setOrigin(double x, double y) {
    setState(() {
      _originX = x;
      _originY = y;
    });
  }

  void _setOriginToCenter() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final size = renderBox.size;
    _setOrigin(size.width / 2, size.height / 2);
  }

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() => _isHovered = value);
    _syncFillAnimation();
  }

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
    _syncFillAnimation();
  }

  void _handleActivate() {
    if (_isInactive) return;
    widget.onPressed();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (_isInactive) return KeyEventResult.ignored;

    final isActivationKey =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space;

    if (!isActivationKey) return KeyEventResult.ignored;

    if (event is KeyDownEvent) {
      _setOriginToCenter();
      _setPressed(true);
      return KeyEventResult.handled;
    }

    if (event is KeyUpEvent && _isPressed) {
      _setPressed(false);
      _handleActivate();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  String? _semanticLabel(Widget child) {
    if (child is Text) {
      return child.data ?? child.textSpan?.toPlainText();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final label = _semanticLabel(widget.child);
    final content = widget.loading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: surakshaAuthText,
            ),
          )
        : widget.child;

    final button = Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: _isInactive,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: MouseRegion(
            onEnter: (event) {
              _setOrigin(event.localPosition.dx, event.localPosition.dy);
              _setHovered(true);
            },
            onHover: (event) {
              if (_isHovered || _isPressed) {
                _setOrigin(event.localPosition.dx, event.localPosition.dy);
              }
            },
            onExit: (_) => _setHovered(false),
            child: Listener(
              onPointerDown: (event) {
                _setOrigin(event.localPosition.dx, event.localPosition.dy);
                _setPressed(true);
              },
              onPointerMove: (event) {
                if (_isPressed || _isHovered) {
                  _setOrigin(event.localPosition.dx, event.localPosition.dy);
                }
              },
              onPointerUp: (event) {
                final wasPressed = _isPressed;
                _setPressed(false);
                if (wasPressed) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final local = renderBox.globalToLocal(event.position);
                    final bounds = Offset.zero & renderBox.size;
                    if (bounds.contains(local)) {
                      _handleActivate();
                    }
                  }
                }
              },
              onPointerCancel: (_) => _setPressed(false),
              child: AnimatedScale(
                scale: _isPressed && !_isInactive ? _tapScale : 1,
                duration: _tapDuration,
                curve: Curves.easeOut,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = _height;
                    final diameter = _getCoverDiameter(
                      width,
                      height,
                      _originX,
                      _originY,
                    );

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(_radius),
                      child: AnimatedBuilder(
                        animation: _fillAnimation,
                        builder: (context, _) {
                          final fillProgress = _fillAnimation.value;
                          final textColor = Color.lerp(
                            surakshaAuthText,
                            surakshaAuthRight,
                            fillProgress,
                          )!;

                          return Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              color: surakshaCard,
                              border: Border.all(
                                color: surakshaBorder,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Positioned(
                                  left: _originX - diameter / 2,
                                  top: _originY - diameter / 2,
                                  child: Transform.scale(
                                    scale: fillProgress,
                                    child: Container(
                                      width: diameter,
                                      height: diameter,
                                      decoration: const BoxDecoration(
                                        color: surakshaAuthText,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: _horizontalPadding,
                                  ),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style:
                                          _labelStyle.copyWith(color: textColor),
                                      child: IconTheme(
                                        data: IconThemeData(
                                          color: textColor,
                                          size: 20,
                                        ),
                                        child: content,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: !_isInactive,
      label: label,
      child: button,
    );
  }
}

double _getCoverDiameter(double width, double height, double x, double y) {
  final distances = [
    math.sqrt(x * x + y * y),
    math.sqrt((width - x) * (width - x) + y * y),
    math.sqrt(x * x + (height - y) * (height - y)),
    math.sqrt((width - x) * (width - x) + (height - y) * (height - y)),
  ];
  return distances.reduce(math.max) * 2;
}
