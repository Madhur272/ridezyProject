// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/widgets/gradient_background.dart';
import 'ride_search_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {

  int selectedVehicle = 0;

  final vehicles = [
    {
      'name': 'Economy',
      'price': '₹220',
      'eta': '3 mins',
      'icon': Icons.local_taxi,
    },
    {
      'name': 'Premium',
      'price': '₹480',
      'eta': '2 mins',
      'icon': Icons.electric_car,
    },
    {
      'name': 'EV Ride',
      'price': '₹340',
      'eta': '4 mins',
      'icon': Icons.ev_station,
    },
  ];

  void bookRide() {

    // Later replace with backend API integration
    // Current stage intentionally mocked for premium UX demo

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RideSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [

              Positioned.fill(
                child: Opacity(
                  opacity: 0.12,
                  child: Image.asset(
                    'assets/images/map_preview.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [

                            Text(
                              'Good Evening',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Madhur',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),

                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Colors.white.withOpacity(0.08),
                          child: const Icon(Icons.notifications),
                        )
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6D5DF6)
                                .withOpacity(0.4),
                            const Color(0xFF00D2FF)
                                .withOpacity(0.2),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                'AI RideScore',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                '96/100',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              Text(
                                'AI Protected Mobility',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              )
                            ],
                          ),

                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                            child: const Icon(
                              Icons.shield,
                              color: Color(0xFF00FFB2),
                              size: 44,
                            ),
                          )
                        ],
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: Colors.black.withOpacity(0.45),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            'Where do you want to go?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [

                                Icon(Icons.my_location),

                                SizedBox(width: 16),

                                Expanded(
                                  child: Text(
                                    'CyberHub, Gurgaon',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vehicles.length,
                              itemBuilder: (_, index) {

                                final vehicle = vehicles[index];

                                final selected =
                                    selectedVehicle == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedVehicle = index;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    width: 180,
                                    margin: const EdgeInsets.only(
                                      right: 18,
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(28),
                                      gradient: selected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF6D5DF6),
                                                Color(0xFF00D2FF),
                                              ],
                                            )
                                          : null,
                                      color: selected
                                          ? null
                                          : Colors.white.withOpacity(0.04),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Icon(
                                          vehicle['icon'] as IconData,
                                          size: 36,
                                        ),

                                        const Spacer(),

                                        Text(
                                          vehicle['name'] as String,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(vehicle['price'] as String),

                                        Text(
                                          vehicle['eta'] as String,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: bookRide,
                            child: Container(
                              height: 72,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(30),
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
                              child: const Center(
                                child: Text(
                                  'Book Smart Ride',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}