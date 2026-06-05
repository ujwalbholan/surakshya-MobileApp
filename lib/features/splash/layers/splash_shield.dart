library splash_shield;

import 'package:flutter/material.dart';
import 'package:suraksha/features/splash/painters/shield_painter.dart';
import 'package:suraksha/features/splash/splash_timeline.dart';
import 'package:suraksha/theme/suraksha_colors.dart';

class SplashShield extends StatelessWidget {
  const SplashShield({
    super.key,
    required this.phases,
    this.disableAnimations = false,
  });

  final SplashPhases phases;
  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    final draw = disableAnimations ? 1.0 : phases.shieldDraw;
    final fill = disableAnimations ? 1.0 : phases.shieldFill;
    final glow = disableAnimations ? 0.8 : phases.shieldGlow;
    final breath = disableAnimations ? 1.0 : phases.holdBreath;

    return Transform.scale(
      scale: breath,
      child: CustomPaint(
        painter: ShieldPainter(
          drawProgress: draw,
          fillProgress: fill,
          glowIntensity: glow,
          crimson: surakshaCrimson,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
