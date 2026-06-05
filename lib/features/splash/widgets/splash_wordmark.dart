library splash_wordmark;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha/theme/suraksha_colors.dart';

class SplashWordmark extends StatelessWidget {
  const SplashWordmark({
    super.key,
    required this.wordmark,
    required this.letterSlides,
    required this.shimmerPos,
    required this.showShimmer,
    required this.opacity,
  });

  final String wordmark;
  final List<Animation<double>> letterSlides;
  final double shimmerPos;
  final bool showShimmer;
  final double opacity;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: opacity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                wordmark.length,
                (i) => ClipRect(
                  child: AnimatedBuilder(
                    animation: letterSlides[i],
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, 48 * letterSlides[i].value),
                      child: Text(
                        wordmark[i],
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: surakshaForeground,
                          letterSpacing: 2,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (showShimmer)
              Positioned.fill(
                child: IgnorePointer(
                  child: ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(shimmerPos - 0.3, 0),
                      end: Alignment(shimmerPos + 0.3, 0),
                      colors: const [
                        Colors.transparent,
                        Color(0x50FFFFFF),
                        Colors.transparent,
                      ],
                    ).createShader(bounds),
                    child: const ColoredBox(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      );
}
