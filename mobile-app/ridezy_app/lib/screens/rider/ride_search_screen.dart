import 'dart:async';

import 'package:flutter/material.dart';

import 'rider_map_screen.dart';

class RideSearchScreen extends StatefulWidget {
  const RideSearchScreen({super.key});

  @override
  State<RideSearchScreen> createState() => _RideSearchScreenState();
}

class _RideSearchScreenState extends State<RideSearchScreen> {

  final List<String> steps = [
    "Checking driver availability",
    "AI safety verification",
    "Locking blockchain escrow",
    "Driver assigned"
  ];

  int currentStep = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (timer) {

      if (currentStep < steps.length - 1) {

        setState(() {
          currentStep++;
        });

      } else {

        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const RiderMapScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const CircularProgressIndicator(),

            const SizedBox(height: 40),

            Text(
              steps[currentStep],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
