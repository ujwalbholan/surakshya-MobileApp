library parallax_widget;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/features/home/home_controller.dart';
import 'package:suraksha/theme/suraksha_animations.dart';

class ParallaxWidget extends ConsumerWidget {
  const ParallaxWidget({
    super.key,
    required this.child,
    required this.sectionOffset,
    this.factor = SurakshaAnimations.parallaxSection,
  });

  final Widget child;
  final double sectionOffset;
  final double factor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = ref.watch(homeScrollNotifierProvider);
    final delta = (scrollOffset - sectionOffset) * factor;
    return Transform.translate(offset: Offset(0, delta), child: child);
  }
}
