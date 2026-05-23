import 'package:flutter/material.dart';

import '../../core/widgets/gradient_background.dart';
import '../auth/role_selector.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController controller = PageController();

  final pages = [
    {
      'title': 'AI Powered Safety',
      'subtitle': 'Real-time computer vision monitoring for every ride.',
      'image': 'assets/images/onboarding_ai.png',
    },
    {
      'title': 'Blockchain Trust',
      'subtitle': 'Decentralized escrow and credibility systems.',
      'image': 'assets/images/onboarding_blockchain.png',
    },
    {
      'title': 'Smart Urban Mobility',
      'subtitle': 'Premium ride experience with intelligent automation.',
      'image': 'assets/images/onboarding_tracking.png',
    },
  ];

  int current = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [

            PageView.builder(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  current = value;
                });
              },
              itemCount: pages.length,
              itemBuilder: (_, index) {

                final page = pages[index];

                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Hero(
                        tag: page['title']!,
                        child: Image.asset(
                          page['image']!,
                          height: 260,
                        ),
                      ),

                      const SizedBox(height: 60),

                      Text(
                        page['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        page['subtitle']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6D5DF6),
                      Color(0xFF00D2FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D2FF)
                          .withOpacity(0.3),
                      blurRadius: 30,
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {

                    if (current == pages.length - 1) {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoleSelector(),
                        ),
                      );

                    } else {

                      controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    current == pages.length - 1
                        ? 'Enter Ridezy'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}