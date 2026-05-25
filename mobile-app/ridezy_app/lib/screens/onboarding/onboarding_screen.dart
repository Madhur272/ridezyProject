// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/auth_gateway.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  int _current = 0;

  final _pages = [
    {
      'title': 'AI Powered Safety',
      'subtitle':
          'Real-time computer vision monitors every ride for lane violations, harsh braking, and driver fatigue.',
      'image': 'assets/images/onboarding_ai.png',
      'lottie': 'assets/lottie/Car GPS.json',
      'color': AppColors.glowPurple,
    },
    {
      'title': 'Blockchain Trust',
      'subtitle':
          'Decentralized escrow and on-chain credibility scoring — no intermediaries, full transparency.',
      'image': 'assets/images/onboarding_blockchain.png',
      'lottie': 'assets/lottie/Successful Payment.json',
      'color': AppColors.glowCyan,
    },
    {
      'title': 'Smart Urban Mobility',
      'subtitle':
          'Premium ride experience with intelligent automation, live tracking, and AI safety monitoring.',
      'image': 'assets/images/onboarding_tracking.png',
      'lottie': 'assets/lottie/2 points map route.json',
      'color': AppColors.glowGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBackground(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (v) => setState(() => _current = v),
                itemCount: _pages.length,
                itemBuilder: (_, index) {
                  final page = _pages[index];
                  final color = page['color'] as Color;
                  return SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Image panel — reduced to 22% height (was 28%)
                          Container(
                            height: size.height * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              // Reduced glow radius by ~25%
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.18),
                                  blurRadius: 18, // was 30
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      color.withOpacity(0.12),
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: color.withOpacity(0.18),
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Image.asset(
                                  page['image'] as String,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms).slideY(
                              begin: 0.15, end: 0, duration: 450.ms),

                          const SizedBox(height: 16),

                          // Lottie — reduced to 13% height (was 16%)
                          SizedBox(
                            height: size.height * 0.13,
                            child: Lottie.asset(
                              page['lottie'] as String,
                              repeat: true,
                              animate: true,
                            ),
                          ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

                          const SizedBox(height: 20),

                          Text(
                            page['title'] as String,
                            textAlign: TextAlign.center,
                            style: AppTypography.sectionTitle(size: 28),
                          ).animate().fadeIn(duration: 500.ms, delay: 250.ms).slideY(
                              begin: 0.15, end: 0, duration: 400.ms),

                          const SizedBox(height: 12),

                          // Fixed opacity — use explicit white color, not textSecondary
                          Text(
                            page['subtitle'] as String,
                            textAlign: TextAlign.center,
                            style: AppTypography.description(
                              size: 14,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ).animate().fadeIn(duration: 500.ms, delay: 350.ms),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: EdgeInsets.only(
                left: 28,
                right: 28,
                bottom: MediaQuery.of(context).padding.bottom + 20,
                top: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _current ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: i == _current
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlowButton(
                    label: _current == _pages.length - 1
                        ? 'Enter Ridezy'
                        : 'Continue',
                    height: 58,
                    onTap: () {
                      if (_current == _pages.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AuthGateway()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
