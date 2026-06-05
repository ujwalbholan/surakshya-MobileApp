library convergence_painter;

import 'package:flutter/material.dart';
import 'package:suraksha/features/splash/models/splash_particle.dart';
import 'package:suraksha/theme/suraksha_colors.dart';

class ConvergencePainter extends CustomPainter {
  ConvergencePainter({
    required this.particles,
    required this.progress,
    required this.centerX,
    required this.centerY,
    required this.screenW,
    required this.screenH,
  });

  final List<SplashConvergenceParticle> particles;
  final double progress;
  final double centerX;
  final double centerY;
  final double screenW;
  final double screenH;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    for (final p in particles) {
      final startX = p.startX * screenW;
      final startY = p.startY * screenH;
      final x = startX + (centerX - startX) * progress;
      final y = startY + (centerY - startY) * progress;

      final trailPaint = Paint()
        ..color = surakshaCrimson.withValues(alpha: 0.4 * (1 - progress))
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(startX, startY), Offset(x, y), trailPaint);

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = surakshaCrimson.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(ConvergencePainter old) => old.progress != progress;
}
