library suraksha_input;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';

/// Shadcn-style text input for auth screens with focus ring and shadow.
class SurakshaInput extends StatefulWidget {
  const SurakshaInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  State<SurakshaInput> createState() => _SurakshaInputState();
}

class _SurakshaInputState extends State<SurakshaInput> {
  static const _minHeight = 36.0;
  static const _animationDuration = Duration(milliseconds: 150);

  static final TextStyle _textStyle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: surakshaAuthText,
  );

  static final TextStyle _hintStyle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: surakshaMuted.withValues(alpha: 0.7),
  );

  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant SurakshaInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _disposeFocusNode();
      _initFocusNode(widget.focusNode);
    }
  }

  void _initFocusNode(FocusNode? focusNode) {
    if (focusNode != null) {
      _focusNode = focusNode;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_onFocusChange);
    _isFocused = _focusNode.hasFocus;
  }

  void _disposeFocusNode() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
  }

  @override
  void dispose() {
    _disposeFocusNode();
    super.dispose();
  }

  void _onFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused == _isFocused) return;
    setState(() => _isFocused = focused);
  }

  BoxShadow get _baseShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 2,
        offset: const Offset(0, 1),
      );

  @override
  Widget build(BuildContext context) {
    final borderColor = _isFocused ? surakshaAuthFocus : surakshaBorder;
    final shadows = _isFocused
        ? [
            BoxShadow(
              color: surakshaAuthFocus.withValues(alpha: 0.2),
              spreadRadius: 3,
            ),
            _baseShadow,
          ]
        : [_baseShadow];

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: _minHeight),
        decoration: BoxDecoration(
          color: surakshaCard,
          borderRadius: BorderRadius.circular(S.radius),
          border: Border.all(color: borderColor),
          boxShadow: shadows,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            cursorColor: surakshaAuthFocus,
            style: _textStyle,
            decoration: InputDecoration.collapsed(
              hintText: widget.placeholder,
              hintStyle: _hintStyle,
            ),
          ),
        ),
      ),
    );
  }
}
