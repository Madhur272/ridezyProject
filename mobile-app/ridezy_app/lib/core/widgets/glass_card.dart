import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassCard extends StatelessWidget {

  final Widget child;
  final double height;

  const GlassCard({
    super.key,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {

    return GlassmorphicContainer(
      width: double.infinity,
      height: height,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white24,
          Colors.white10,
        ],
      ),
      child: child,
    );
  }
}
