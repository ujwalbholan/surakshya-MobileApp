library cosmic_background_painter;

import 'dart:math' as math;

import 'package:flutter/material.dart';

class CosmicBackgroundPainter extends CustomPainter {
  CosmicBackgroundPainter({
    required this.progress,
    required this.centerX,
    required this.centerY,
    this.breathScale = 1.0,
    this.time = 0,
  });

  final double progress;
  final double centerX;
  final double centerY;
  final double breathScale;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Rich base — not flat black
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0508),
            Color(0xFF12080C),
            Color(0xFF050505),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final driftX = math.sin(time * 2 * math.pi) * 24;
    final driftY = math.cos(time * 2 * math.pi * 0.7) * 18;

    final coreRadius = size.longestSide * 0.55 * breathScale * progress;
    if (coreRadius > 0) {
      canvas.drawCircle(
        Offset(centerX + driftX, centerY + driftY),
        coreRadius,
        Paint()
          ..shader = const RadialGradient(
            colors: [
              Color(0x55C0392B),
              Color(0x28E74C3C),
              Color(0x12C0392B),
              Colors.transparent,
            ],
            stops: [0.0, 0.25, 0.5, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(centerX + driftX, centerY + driftY),
              radius: coreRadius,
            ),
          ),
      );
    }

    // Secondary warm nebula blob (moves opposite)
    final blob2 = coreRadius * 0.65;
    if (blob2 > 20) {
      canvas.drawCircle(
        Offset(
          centerX - driftX * 1.4,
          centerY - driftY * 1.2 + size.height * 0.08,
        ),
        blob2,
        Paint()
          ..shader = const RadialGradient(
            colors: [
              Color(0x20FF6B4A),
              Color(0x08C0392B),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(
                centerX - driftX * 1.4,
                centerY - driftY * 1.2,
              ),
              radius: blob2,
            ),
          ),
      );
    }

    // Soft vignette
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.35 * progress),
          ],
          stops: const [0.45, 1.0],
        ).createShader(
          Rect.fromCircle(
            center: Offset(centerX, centerY),
            radius: size.longestSide * 0.75,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(CosmicBackgroundPainter old) =>
      old.progress != progress ||
      old.breathScale != breathScale ||
      old.time != time;
}
