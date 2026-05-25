// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Shared animated background: deep dark base + floating particles + gradient mesh
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Deep dark base — no washed-out grey
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF010409), Color(0xFF020817), Color(0xFF010409)],
        ),
      ),
      child: Stack(
        children: [
          // Animated gradient mesh blobs
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _MeshPainter(_ctrl.value),
              child: const SizedBox.expand(),
            ),
          ),
          // Floating particles
          if (widget.showParticles)
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(_ctrl.value),
                child: const SizedBox.expand(),
              ),
            ),
          // Subtle scanline overlay for futuristic feel
          Positioned.fill(
            child: CustomPaint(painter: _ScanlinePainter()),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double t;
  _MeshPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      // top-left purple blob
      _Blob(
        cx: size.width * (0.1 + 0.08 * math.sin(t * math.pi * 2)),
        cy: size.height * (0.15 + 0.06 * math.cos(t * math.pi * 2)),
        r: size.width * 0.45,
        color: const Color(0xFF6D5DF6).withOpacity(0.10),
      ),
      // bottom-right cyan blob
      _Blob(
        cx: size.width * (0.85 + 0.06 * math.cos(t * math.pi * 2 + 1.0)),
        cy: size.height * (0.75 + 0.08 * math.sin(t * math.pi * 2 + 1.0)),
        r: size.width * 0.5,
        color: const Color(0xFF00D2FF).withOpacity(0.08),
      ),
      // center green accent
      _Blob(
        cx: size.width * (0.5 + 0.1 * math.sin(t * math.pi * 2 + 2.0)),
        cy: size.height * (0.5 + 0.07 * math.cos(t * math.pi * 2 + 2.0)),
        r: size.width * 0.3,
        color: const Color(0xFF00FFB2).withOpacity(0.05),
      ),
    ];

    for (final b in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [b.color, b.color.withOpacity(0)],
        ).createShader(Rect.fromCircle(
          center: Offset(b.cx, b.cy),
          radius: b.r,
        ));
      canvas.drawCircle(Offset(b.cx, b.cy), b.r, paint);
    }
  }

  @override
  bool shouldRepaint(_MeshPainter old) => old.t != t;
}

class _Blob {
  final double cx, cy, r;
  final Color color;
  const _Blob({required this.cx, required this.cy, required this.r, required this.color});
}

class _ParticlePainter extends CustomPainter {
  final double t;
  static final _rng = math.Random(42);
  static final _particles = List.generate(28, (i) => _Particle(_rng, i));

  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final progress = (t + p.offset) % 1.0;
      final x = p.x * size.width;
      final y = (p.y + progress * p.speed) % 1.0 * size.height;
      final opacity = (math.sin(progress * math.pi) * p.alpha).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

class _Particle {
  final double x, y, speed, alpha, radius, offset;
  final Color color;

  _Particle(math.Random rng, int seed)
      : x = math.Random(seed * 7).nextDouble(),
        y = math.Random(seed * 13).nextDouble(),
        speed = 0.08 + math.Random(seed * 3).nextDouble() * 0.12,
        alpha = 0.15 + math.Random(seed * 5).nextDouble() * 0.35,
        radius = 0.8 + math.Random(seed * 11).nextDouble() * 1.6,
        offset = math.Random(seed * 17).nextDouble(),
        color = [
          const Color(0xFF6D5DF6),
          const Color(0xFF00D2FF),
          const Color(0xFF00FFB2),
        ][seed % 3];
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.012)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter _) => false;
}
