// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_background.dart';
import 'ride_lifecycle_screen.dart';

class RideSearchScreen extends StatefulWidget {
  const RideSearchScreen({super.key});

  @override
  State<RideSearchScreen> createState() => _RideSearchScreenState();
}

class _RideSearchScreenState extends State<RideSearchScreen> {
  final _steps = [
    ('Checking driver availability', AppColors.glowCyan, Icons.search_rounded),
    ('AI safety verification', AppColors.glowPurple, Icons.psychology_rounded),
    ('Locking blockchain escrow', AppColors.glowAmber, Icons.lock_rounded),
    ('Driver assigned!', AppColors.glowGreen, Icons.check_circle_rounded),
  ];

  int _currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_currentStep < _steps.length - 1) {
        setState(() => _currentStep++);
      } else {
        t.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RideLifecycleScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _steps[_currentStep];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Lottie - constrained, not Positioned.fill
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  repeat: true,
                  animate: true,
                ),
              ).animate().fadeIn(duration: 600.ms),

              const SizedBox(height: 32),

              Text('Finding Your Ride',
                      style: AppTypography.sectionTitle(size: 28))
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms),

              const SizedBox(height: 8),

              Text('AI-powered matching in progress',
                      style: AppTypography.description(size: 14))
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 40),

              // Step list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: List.generate(_steps.length, (i) {
                    final (stepLabel, stepColor, stepIcon) = _steps[i];
                    final isDone = i < _currentStep;
                    final isCurrent = i == _currentStep;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        borderRadius: 16,
                        glowColor: isCurrent ? stepColor : Colors.transparent,
                        glowIntensity: isCurrent ? 0.2 : 0,
                        gradient: LinearGradient(
                          colors: isCurrent
                              ? [
                                  stepColor.withOpacity(0.15),
                                  stepColor.withOpacity(0.04),
                                ]
                              : [
                                  Colors.white.withOpacity(0.04),
                                  Colors.white.withOpacity(0.01),
                                ],
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isDone || isCurrent)
                                    ? stepColor.withOpacity(0.15)
                                    : Colors.white.withOpacity(0.05),
                              ),
                              child: Icon(
                                isDone ? Icons.check_rounded : stepIcon,
                                size: 16,
                                color: (isDone || isCurrent)
                                    ? stepColor
                                    : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              stepLabel,
                              style: AppTypography.description(
                                size: 14,
                                color: isCurrent
                                    ? AppColors.textPrimary
                                    : isDone
                                        ? stepColor
                                        : AppColors.textMuted,
                              ),
                            ),
                            const Spacer(),
                            if (isCurrent)
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: stepColor,
                                ),
                              ),
                            if (isDone)
                              Icon(Icons.check_rounded,
                                  color: stepColor, size: 16),
                          ],
                        ),
                      ).animate(key: ValueKey('$i-$isCurrent')).fadeIn(
                            duration: 300.ms,
                            delay: (i * 60).ms,
                          ),
                    );
                  }),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
