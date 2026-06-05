library film_grain_overlay;

import 'package:flutter/material.dart';
import 'package:suraksha/widgets/decorators/noise_painter.dart';

class FilmGrainOverlay extends StatefulWidget {
  const FilmGrainOverlay({super.key, this.opacity = 0.03});

  final double opacity;

  @override
  State<FilmGrainOverlay> createState() => _FilmGrainOverlayState();
}

class _FilmGrainOverlayState extends State<FilmGrainOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: NoisePainter(
              seed: (_controller.value * 1000).toInt(),
              opacity: widget.opacity,
            ),
          ),
        ),
      );
}
