// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/colors.dart';
import '../constants/typography.dart';
import 'glass_card.dart';

/// Full vehicle approaching widget: radar rings + route line + ETA + driver card + AI pulse
class VehicleApproachingWidget extends StatefulWidget {
  const VehicleApproachingWidget({super.key});

  @override
  State<VehicleApproachingWidget> createState() =>
      _VehicleApproachingWidgetState();
}

class _VehicleApproachingWidgetState extends State<VehicleApproachingWidget>
    with TickerProviderStateMixin {
  late AnimationController _radarCtrl;
  late AnimationController _routeCtrl;
  late AnimationController _etaCtrl;
  late AnimationController _aiPulseCtrl;

  // Simulated ETA countdown
  int _etaSeconds = 180; // 3 min
  double _speed = 28.0;

  @override
  void initState() {
    super.initState();
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _routeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _etaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _aiPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Countdown ETA
    _etaCtrl.addListener(() {
      if (_etaCtrl.value > 0.99 && _etaSeconds > 0) {
        setState(() {
          _etaSeconds--;
          _speed = 24 + math.Random().nextDouble() * 12;
        });
      }
    });
  }

  @override
  void dispose() {
    _radarCtrl.dispose();
    _routeCtrl.dispose();
    _etaCtrl.dispose();
    _aiPulseCtrl.dispose();
    super.dispose();
  }

  String get _etaLabel {
    final m = _etaSeconds ~/ 60;
    final s = _etaSeconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Radar + route visualization
        SizedBox(
          width: 200,
          height: 200,
          child: AnimatedBuilder(
            animation: Listenable.merge([_radarCtrl, _routeCtrl]),
            builder: (_, __) => CustomPaint(
              painter: _RadarRoutePainter(
                radarT: _radarCtrl.value,
                routeT: _routeCtrl.value,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ETA + Speed row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MetricPill(
              icon: Icons.timer_rounded,
              color: AppColors.glowAmber,
              label: 'ETA',
              value: _etaLabel,
            ),
            const SizedBox(width: 12),
            _MetricPill(
              icon: Icons.speed_rounded,
              color: AppColors.glowCyan,
              label: 'Speed',
              value: '${_speed.toStringAsFixed(0)} km/h',
            ),
            const SizedBox(width: 12),
            _MetricPill(
              icon: Icons.near_me_rounded,
              color: AppColors.glowGreen,
              label: 'Away',
              value: '0.8 km',
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Driver avatar card
        GlassCard(
          padding: const EdgeInsets.all(14),
          borderRadius: 18,
          glowColor: AppColors.glowGreen,
          glowIntensity: 0.12,
          child: Row(
            children: [
              // Avatar with online ring
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradientPrimary,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 26),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: _aiPulseCtrl,
                      builder: (_, __) => Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glowGreen,
                          border: Border.all(
                              color: AppColors.surface, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.glowGreen.withOpacity(
                                  0.4 + _aiPulseCtrl.value * 0.4),
                              blurRadius: 6 + _aiPulseCtrl.value * 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arjun Singh',
                        style: AppTypography.cardHeading(size: 15)),
                    Text('Tesla Model 3 · MH 01 AB 1234',
                        style: AppTypography.metadata(size: 11)),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.glowAmber, size: 14),
                      const SizedBox(width: 3),
                      Text('4.92',
                          style: AppTypography.label(
                              size: 12, color: AppColors.glowAmber)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('847 rides',
                      style: AppTypography.metadata(size: 10)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // AI monitoring status
        AnimatedBuilder(
          animation: _aiPulseCtrl,
          builder: (_, __) => Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.glowGreen.withOpacity(0.08),
              border: Border.all(
                color: AppColors.glowGreen.withOpacity(
                    0.2 + _aiPulseCtrl.value * 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glowGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowGreen.withOpacity(
                            0.5 + _aiPulseCtrl.value * 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('AI Safety Monitoring Active',
                    style: AppTypography.label(
                        size: 11, color: AppColors.glowGreen)),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms),
      ],
    );
  }
}

class _MetricPill extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _MetricPill(
      {required this.icon,
      required this.color,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(height: 3),
          Text(value,
              style: AppTypography.label(size: 12, color: color)),
          Text(label, style: AppTypography.metadata(size: 10)),
        ],
      ),
    );
  }
}

class _RadarRoutePainter extends CustomPainter {
  final double radarT;
  final double routeT;

  _RadarRoutePainter({required this.radarT, required this.routeT});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.width * 0.46;

    // ── Radar rings (3 expanding) ──────────────────────────────
    for (int i = 0; i < 3; i++) {
      final t = (radarT + i / 3.0) % 1.0;
      final r = t * maxR;
      final opacity = (1.0 - t) * 0.5;
      final paint = Paint()
        ..color = const Color(0xFFFFB800).withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }

    // ── Static grid rings ──────────────────────────────────────
    for (final r in [maxR * 0.33, maxR * 0.66, maxR]) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }

    // ── Cross hairs ────────────────────────────────────────────
    final crossPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(cx, cy - maxR), Offset(cx, cy + maxR), crossPaint);
    canvas.drawLine(Offset(cx - maxR, cy), Offset(cx + maxR, cy), crossPaint);

    // ── Animated route line (dashed, moving) ──────────────────
    final routeStart = Offset(cx, cy + maxR * 0.85);
    final routeEnd = Offset(cx, cy - maxR * 0.1);
    _drawAnimatedDash(canvas, routeStart, routeEnd, routeT);

    // ── Destination marker (top) ───────────────────────────────
    final destPaint = Paint()
      ..color = const Color(0xFF00FFB2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(routeEnd, 5, destPaint);
    canvas.drawCircle(
        routeEnd,
        9,
        Paint()
          ..color = const Color(0xFF00FFB2).withOpacity(0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // ── Vehicle dot (animated along route) ────────────────────
    final vehicleY = routeStart.dy +
        (routeEnd.dy - routeStart.dy) * (0.3 + routeT * 0.4);
    final vehiclePos = Offset(cx, vehicleY);
    canvas.drawCircle(
        vehiclePos,
        7,
        Paint()
          ..color = const Color(0xFFFFB800)
          ..style = PaintingStyle.fill);
    canvas.drawCircle(
        vehiclePos,
        12,
        Paint()
          ..color = const Color(0xFFFFB800).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // ── Center dot (user) ──────────────────────────────────────
    canvas.drawCircle(
        Offset(cx, cy + maxR * 0.85),
        4,
        Paint()
          ..color = const Color(0xFF6D5DF6)
          ..style = PaintingStyle.fill);
  }

  void _drawAnimatedDash(
      Canvas canvas, Offset start, Offset end, double t) {
    final total = (end - start).distance;
    final dashLen = 8.0;
    final gapLen = 5.0;
    final period = dashLen + gapLen;
    final offset = t * period;
    final dir = (end - start) / total;
    final paint = Paint()
      ..color = const Color(0xFF00D2FF).withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double d = -offset % period;
    while (d < total) {
      final s = d.clamp(0.0, total);
      final e = (d + dashLen).clamp(0.0, total);
      if (e > s) {
        canvas.drawLine(
          start + dir * s,
          start + dir * e,
          paint,
        );
      }
      d += period;
    }
  }

  @override
  bool shouldRepaint(_RadarRoutePainter old) =>
      old.radarT != radarT || old.routeT != routeT;
}
