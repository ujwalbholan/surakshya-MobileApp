library scalloped_icon_bezel;

import 'package:flutter/material.dart';
import 'package:suraksha/widgets/ticket_status_card/scalloped_bezel_clipper.dart';

/// Default diameter of the scalloped icon bezel.
const double kScallopedIconBezelSize = 48;

/// A scalloped circular frame with a gradient fill and centered child.
class ScallopedIconBezel extends StatelessWidget {
  const ScallopedIconBezel({
    super.key,
    required this.colors,
    required this.child,
    this.size = kScallopedIconBezelSize,
    this.lobeCount = kScallopedBezelLobeCount,
    this.lobeDepth = kScallopedBezelLobeDepth,
  });

  final List<Color> colors;
  final Widget child;
  final double size;
  final int lobeCount;
  final double lobeDepth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: ScallopedBezelClipper(
          lobeCount: lobeCount,
          lobeDepth: lobeDepth,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
