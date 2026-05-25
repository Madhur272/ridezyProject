// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_background.dart';
import '../driver/driver_home_screen.dart';
import '../rider/rider_home_screen.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowCyan.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: Image.asset(
                          'assets/images/ridezy_logo.png',
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 700.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 28),

                Text('Choose Your Role', style: AppTypography.heroTitle(size: 36))
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),

                const SizedBox(height: 10),

                Text(
                  'Next-gen AI mobility for riders and drivers.',
                  textAlign: TextAlign.center,
                  style: AppTypography.description(size: 15),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 450.ms),

                const SizedBox(height: 48),

                _RoleCard(
                  title: 'Ride with AI Safety',
                  subtitle: 'Premium smart mobility with blockchain trust and real-time AI protection.',
                  icon: Icons.person_rounded,
                  color: AppColors.glowPurple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RiderHomeScreen()),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),

                const SizedBox(height: 16),

                _RoleCard(
                  title: 'Drive with Ridezy',
                  subtitle: 'Earn with intelligent decentralized mobility and AI-verified credibility.',
                  icon: Icons.directions_car_rounded,
                  color: AppColors.glowCyan,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 750.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: GlassCard(
          glowColor: widget.color,
          glowIntensity: 0.18,
          gradient: LinearGradient(
            colors: [
              widget.color.withOpacity(0.12),
              widget.color.withOpacity(0.04),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTypography.cardHeading(size: 19)),
                    const SizedBox(height: 6),
                    Text(widget.subtitle,
                        style: AppTypography.description(size: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: widget.color, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
