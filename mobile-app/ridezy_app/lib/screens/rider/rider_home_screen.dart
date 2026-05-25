// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/primary_button.dart';
import 'ride_search_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  int _selectedVehicle = 0;

  final _vehicles = [
    {
      'name': 'Economy',
      'price': '₹220',
      'eta': '3 min',
      'icon': Icons.local_taxi,
      'color': AppColors.glowPurple,
    },
    {
      'name': 'Premium',
      'price': '₹480',
      'eta': '2 min',
      'icon': Icons.electric_car,
      'color': AppColors.glowCyan,
    },
    {
      'name': 'EV Ride',
      'price': '₹340',
      'eta': '4 min',
      'icon': Icons.ev_station,
      'color': AppColors.glowGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Evening', style: AppTypography.metadata(size: 14)),
                        const SizedBox(height: 4),
                        Text('Madhur', style: AppTypography.heroTitle(size: 36)),
                      ],
                    ),
                    GlassCard(
                      padding: const EdgeInsets.all(12),
                      borderRadius: 16,
                      glowColor: AppColors.glowPurple,
                      child: const Icon(Icons.notifications_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0, duration: 500.ms),
              ),

              const SizedBox(height: 20),

              // ── AI RideScore card ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  glowColor: AppColors.glowGreen,
                  glowIntensity: 0.25,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.25),
                      AppColors.secondary.withOpacity(0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI RideScore', style: AppTypography.label()),
                          const SizedBox(height: 6),
                          Text('96/100', style: AppTypography.dataDisplay(size: 40)),
                          const SizedBox(height: 4),
                          Text('AI Protected Mobility',
                              style: AppTypography.description(size: 13)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glowGreen.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.glowGreen.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shield_rounded,
                            color: AppColors.glowGreen, size: 40),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),
              ),

              const Spacer(),

              // ── Destination + booking panel ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GlassCard(
                  borderRadius: 32,
                  glowColor: AppColors.glowCyan,
                  glowIntensity: 0.12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Where to?', style: AppTypography.sectionTitle(size: 26)),
                      const SizedBox(height: 16),

                      // Location row
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        borderRadius: 16,
                        glowColor: AppColors.glowCyan,
                        glowIntensity: 0.08,
                        child: Row(
                          children: [
                            const Icon(Icons.my_location_rounded,
                                color: AppColors.secondary, size: 20),
                            const SizedBox(width: 12),
                            Text('CyberHub, Gurgaon',
                                style: AppTypography.description(
                                    size: 15, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Vehicle selector
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _vehicles.length,
                          itemBuilder: (_, i) {
                            final v = _vehicles[i];
                            final selected = _selectedVehicle == i;
                            final color = v['color'] as Color;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedVehicle = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                width: 160,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: selected
                                      ? LinearGradient(
                                          colors: [
                                            color.withOpacity(0.5),
                                            color.withOpacity(0.25),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.06),
                                            Colors.white.withOpacity(0.02),
                                          ],
                                        ),
                                  border: Border.all(
                                    color: selected
                                        ? color.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.08),
                                    width: selected ? 1.5 : 1,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: color.withOpacity(0.3),
                                            blurRadius: 16,
                                            spreadRadius: 0,
                                          )
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(v['icon'] as IconData,
                                        color: selected ? color : AppColors.textSecondary,
                                        size: 28),
                                    const Spacer(),
                                    Text(v['name'] as String,
                                        style: AppTypography.cardHeading(
                                            size: 16,
                                            color: selected
                                                ? AppColors.textPrimary
                                                : AppColors.textSecondary)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(v['price'] as String,
                                            style: AppTypography.cardHeading(
                                                size: 15,
                                                color: selected
                                                    ? AppColors.textPrimary
                                                    : AppColors.textSecondary)),
                                        const SizedBox(width: 6),
                                        Text(v['eta'] as String,
                                            style: AppTypography.metadata(
                                                size: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      GlowButton(
                        label: 'Book Smart Ride',
                        height: 60,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RideSearchScreen()),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
