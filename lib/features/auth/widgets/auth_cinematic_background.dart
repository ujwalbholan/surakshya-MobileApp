library auth_cinematic_background;

import 'package:flutter/material.dart';
import 'package:suraksha/features/splash/layers/splash_scene.dart';
import 'package:suraksha/features/splash/splash_master_controller.dart';
import 'package:suraksha/features/splash/splash_timeline.dart';

/// Shared hold-frame cinematic background for auth screens.
///
/// Renders splash atmosphere and wristband at [SplashMasterController.holdT]
/// without brand copy. When [disableAnimations] is true (default), particles
/// are hidden and wristband idle motion is disabled — matching splash
/// reduced-motion behavior.
class AuthCinematicBackground extends StatelessWidget {
  const AuthCinematicBackground({
    super.key,
    this.disableAnimations = true,
  });

  final bool disableAnimations;

  @override
  Widget build(BuildContext context) {
    return SplashScene(
      phases: const SplashPhases(SplashMasterController.holdT),
      disableAnimations: disableAnimations,
      showBrandPanel: false,
    );
  }
}
