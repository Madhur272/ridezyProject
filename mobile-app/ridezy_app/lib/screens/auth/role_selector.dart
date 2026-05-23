import 'package:flutter/material.dart';

import '../../core/widgets/gradient_background.dart';
import '../driver/driver_home_screen.dart';
import '../rider/rider_home_screen.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  Widget roleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D5DF6)
                  .withOpacity(0.15),
              blurRadius: 40,
            )
          ],
        ),
        child: Row(
          children: [

            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6D5DF6),
                    Color(0xFF00D2FF),
                  ],
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 34,
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/images/ridezy_logo.png',
                height: 140,
              ),

              const SizedBox(height: 30),

              const Text(
                'Choose Your Experience',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14),

              const Text(
                'Next-generation AI mobility for riders and drivers.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 60),

              roleCard(
                context: context,
                title: 'Ride with AI Safety',
                subtitle: 'Premium smart mobility with blockchain trust.',
                icon: Icons.person,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RiderHomeScreen(),
                    ),
                  );
                },
              ),

              roleCard(
                context: context,
                title: 'Drive with Ridezy',
                subtitle: 'Earn with intelligent decentralized mobility.',
                icon: Icons.directions_car,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DriverHomeScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}