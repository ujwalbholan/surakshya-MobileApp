library splash_chrome;

import 'package:flutter/material.dart';

/// Top crimson bar, crosshairs, bottom fade.
class SplashChrome extends StatelessWidget {
  const SplashChrome({super.key, this.opacity = 1});

  final double opacity;

  static const _crosshairStyle = TextStyle(
    color: Color(0x99333333),
    fontSize: 14,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: const IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopBarLine(),
            ),
            Positioned(top: 24, left: 24, child: Text('+', style: _crosshairStyle)),
            Positioned(top: 24, right: 24, child: Text('+', style: _crosshairStyle)),
            Positioned(
              bottom: 24,
              left: 24,
              child: Text('+', style: _crosshairStyle),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: Text('+', style: _crosshairStyle),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF000000),
                      Color(0xB3000000),
                      Color(0x00000000),
                    ],
                    stops: [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarLine extends StatelessWidget {
  const _TopBarLine();

  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x00000000),
              Color(0xFFC0392B),
              Color(0xFFE74C3C),
              Color(0xFFC0392B),
              Color(0x00000000),
            ],
            stops: [0.0, 0.2, 0.5, 0.8, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x66C0392B),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Color(0x14C0392B),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
      );
}
