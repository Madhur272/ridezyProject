// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _navTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with strong cyan glow pulse
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, child) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Strong outer cyan glow
                      BoxShadow(
                        color: AppColors.glowCyan.withOpacity(
                            0.35 + _glowCtrl.value * 0.35),
                        blurRadius: 48 + _glowCtrl.value * 24,
                        spreadRadius: 4,
                      ),
                      // Inner purple accent
                      BoxShadow(
                        color: AppColors.glowPurple.withOpacity(
                            0.2 + _glowCtrl.value * 0.15),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: child,
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.35),
                        border: Border.all(
                          color: AppColors.glowCyan.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/ridezy_logo.png',
                        height: 150,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 800.ms),

              const SizedBox(height: 28),

              ShaderMask(
                shaderCallback: (r) => AppColors.gradientPrimary
                    .createShader(Rect.fromLTWH(0, 0, r.width, r.height)),
                child: Text('Ridezy', style: AppTypography.heroTitle(size: 52)),
              )
                  .animate()
                  .fadeIn(duration: 700.ms, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0, duration: 500.ms),

              const SizedBox(height: 10),

              Text(
                'AI Powered Decentralized Mobility',
                style: AppTypography.description(
                    size: 15, color: AppColors.textSecondary),
              )
                  .animate()
                  .fadeIn(duration: 700.ms, delay: 650.ms),

              const SizedBox(height: 52),

              SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  repeat: true,
                  animate: true,
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
