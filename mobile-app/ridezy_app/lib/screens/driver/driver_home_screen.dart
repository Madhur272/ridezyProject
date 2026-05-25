// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/primary_button.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  bool _hasNewRide = false;
  late AnimationController _onlineGlow;

  // Mock earnings data (Mon–Sun)
  final List<double> _weeklyEarnings = [1240, 1850, 980, 2100, 1650, 2450, 1900];
  final List<String> _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Mock heatmap data (hour × intensity)
  final List<List<double>> _heatmap = List.generate(
    6,
    (row) => List.generate(
      8,
      (col) => math.Random(row * 8 + col).nextDouble(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _onlineGlow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void dispose() {
    _onlineGlow.dispose();
    super.dispose();
  }

  void _toggleOnline() {
    setState(() {
      _isOnline = !_isOnline;
      _hasNewRide = _isOnline;
    });
    if (_isOnline) {
      _onlineGlow.repeat(reverse: true);
    } else {
      _onlineGlow.stop();
      _onlineGlow.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildOnlineToggle()),
              if (_isOnline && _hasNewRide)
                SliverToBoxAdapter(child: _buildNewRideCard()),
              SliverToBoxAdapter(child: _buildStatsRow()),
              SliverToBoxAdapter(child: _buildEarningsChart()),
              SliverToBoxAdapter(child: _buildAIMetrics()),
              SliverToBoxAdapter(child: _buildVehicleStatus()),
              SliverToBoxAdapter(child: _buildHeatmap()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Driver Dashboard', style: AppTypography.metadata(size: 13)),
              const SizedBox(height: 4),
              Text('Arjun Singh', style: AppTypography.heroTitle(size: 32)),
            ],
          ),
          Row(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(10),
                borderRadius: 14,
                glowColor: AppColors.glowPurple,
                child: const Icon(Icons.notifications_outlined,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 500.ms)
          .slideY(begin: -0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _buildOnlineToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: AnimatedBuilder(
        animation: _onlineGlow,
        builder: (_, __) => GlassCard(
          glowColor: _isOnline ? AppColors.glowGreen : AppColors.glowPurple,
          glowIntensity: _isOnline ? 0.15 + _onlineGlow.value * 0.2 : 0.1,
          gradient: LinearGradient(
            colors: _isOnline
                ? [
                    AppColors.glowGreen.withOpacity(0.15),
                    AppColors.glowGreen.withOpacity(0.05),
                  ]
                : [
                    Colors.white.withOpacity(0.07),
                    Colors.white.withOpacity(0.02),
                  ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isOnline ? 'You\'re Online' : 'You\'re Offline',
                    style: AppTypography.cardHeading(
                      size: 20,
                      color: _isOnline ? AppColors.glowGreen : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isOnline
                        ? 'Accepting ride requests'
                        : 'Go online to start earning',
                    style: AppTypography.description(size: 13),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleOnline,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 64,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: _isOnline
                        ? AppColors.glowGreen
                        : AppColors.textMuted.withOpacity(0.4),
                    boxShadow: _isOnline
                        ? [
                            BoxShadow(
                              color: AppColors.glowGreen.withOpacity(0.5),
                              blurRadius: 12,
                            )
                          ]
                        : [],
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: _isOnline ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }

  Widget _buildNewRideCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: GlassCard(
        glowColor: AppColors.glowAmber,
        glowIntensity: 0.3,
        gradient: LinearGradient(
          colors: [
            AppColors.glowAmber.withOpacity(0.18),
            AppColors.glowAmber.withOpacity(0.06),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.glowAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glowAmber.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glowAmber,
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .fadeOut(duration: 600.ms)
                          .then()
                          .fadeIn(duration: 600.ms),
                      const SizedBox(width: 6),
                      Text('NEW RIDE',
                          style: AppTypography.label(
                              size: 11, color: AppColors.glowAmber)),
                    ],
                  ),
                ),
                const Spacer(),
                Text('₹340', style: AppTypography.dataDisplay(size: 28)),
              ],
            ),
            const SizedBox(height: 16),
            _rideLocationRow(
              Icons.radio_button_checked,
              AppColors.glowGreen,
              'Sector 29, Gurgaon',
              'Pickup',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Container(
                width: 1.5,
                height: 20,
                color: AppColors.textMuted.withOpacity(0.4),
              ),
            ),
            _rideLocationRow(
              Icons.location_on,
              AppColors.error,
              'Cyber City, DLF Phase 2',
              'Drop',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _rideMetaChip(Icons.straighten, '4.2 km'),
                const SizedBox(width: 10),
                _rideMetaChip(Icons.access_time, '12 min'),
                const SizedBox(width: 10),
                _rideMetaChip(Icons.star_rounded, '4.8 rider'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlowButton(
                    label: 'Accept',
                    height: 50,
                    gradientColors: [
                      AppColors.glowGreen.withOpacity(0.8),
                      AppColors.glowGreen,
                    ],
                    glowColor: AppColors.glowGreen,
                    onTap: () => setState(() => _hasNewRide = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlineButton(
                    label: 'Decline',
                    height: 50,
                    borderColor: AppColors.error,
                    textColor: AppColors.error,
                    onTap: () => setState(() => _hasNewRide = false),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut),
    );
  }

  Widget _rideLocationRow(IconData icon, Color color, String address, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.metadata(size: 11)),
            Text(address,
                style: AppTypography.description(
                    size: 14, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _rideMetaChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.metadata(size: 11)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Overview", style: AppTypography.sectionTitle(size: 22)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GlowStatCard(
                  label: "Today's Earnings",
                  value: '₹2,450',
                  icon: Icons.currency_rupee,
                  color: AppColors.glowGreen,
                  subtitle: '+18%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlowStatCard(
                  label: 'Rides Completed',
                  value: '14',
                  icon: Icons.directions_car,
                  color: AppColors.glowCyan,
                  subtitle: 'Today',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GlowStatCard(
                  label: 'AI Safety Score',
                  value: '96/100',
                  icon: Icons.shield_rounded,
                  color: AppColors.glowPurple,
                  subtitle: 'Excellent',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlowStatCard(
                  label: 'Credibility Score',
                  value: '4.92',
                  icon: Icons.verified,
                  color: AppColors.glowAmber,
                  subtitle: 'Top 5%',
                ),
              ),
            ],
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 200.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _buildEarningsChart() {
    final maxVal = _weeklyEarnings.reduce(math.max);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GlassCard(
        glowColor: AppColors.glowCyan,
        glowIntensity: 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Earnings', style: AppTypography.cardHeading(size: 18)),
                Text('₹12,170 total',
                    style: AppTypography.label(color: AppColors.glowCyan)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text(
                          _weekDays[v.toInt()],
                          style: AppTypography.metadata(size: 11),
                        ),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.white.withOpacity(0.05),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    _weeklyEarnings.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _weeklyEarnings[i],
                          width: 22,
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: i == 5
                                ? [AppColors.glowGreen, AppColors.secondary]
                                : [
                                    AppColors.primary.withOpacity(0.8),
                                    AppColors.secondary.withOpacity(0.6),
                                  ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 300.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _buildAIMetrics() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GlassCard(
        glowColor: AppColors.glowPurple,
        glowIntensity: 0.15,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.primary.withOpacity(0.04),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.psychology,
                      color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text('AI Safety Analytics', style: AppTypography.cardHeading(size: 18)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.glowGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Live',
                      style: AppTypography.label(
                          size: 11, color: AppColors.glowGreen)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _aiMetricRow('Lane Violations', '0', AppColors.glowGreen, 1.0),
            const SizedBox(height: 10),
            _aiMetricRow('Harsh Braking', '1', AppColors.glowAmber, 0.85),
            const SizedBox(height: 10),
            _aiMetricRow('Distraction Events', '0', AppColors.glowGreen, 1.0),
            const SizedBox(height: 10),
            _aiMetricRow('Speed Compliance', '98%', AppColors.glowCyan, 0.98),
            const SizedBox(height: 10),
            _aiMetricRow('Drowsiness Score', 'Alert', AppColors.glowGreen, 1.0),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 350.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _aiMetricRow(String label, String value, Color color, double progress) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(label, style: AppTypography.description(size: 13)),
        ),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 44,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.label(size: 13, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GlassCard(
        glowColor: AppColors.glowCyan,
        glowIntensity: 0.12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicle Status', style: AppTypography.cardHeading(size: 18)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _vehicleStatItem(
                    Icons.battery_charging_full,
                    AppColors.glowGreen,
                    '78%',
                    'Battery',
                  ),
                ),
                Expanded(
                  child: _vehicleStatItem(
                    Icons.speed,
                    AppColors.glowCyan,
                    '0 km/h',
                    'Speed',
                  ),
                ),
                Expanded(
                  child: _vehicleStatItem(
                    Icons.route,
                    AppColors.glowPurple,
                    '284 km',
                    'Range',
                  ),
                ),
                Expanded(
                  child: _vehicleStatItem(
                    Icons.thermostat,
                    AppColors.glowAmber,
                    '32°C',
                    'Engine',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Battery bar
            Row(
              children: [
                Text('Battery', style: AppTypography.metadata(size: 12)),
                const Spacer(),
                Text('78%',
                    style: AppTypography.label(
                        size: 12, color: AppColors.glowGreen)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.78,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.glowGreen),
                minHeight: 8,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 400.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Widget _vehicleStatItem(
      IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(value,
            style: AppTypography.cardHeading(size: 14, color: color)),
        Text(label, style: AppTypography.metadata(size: 11)),
      ],
    );
  }

  Widget _buildHeatmap() {
    final hours = ['6am', '9am', '12pm', '3pm', '6pm', '9pm', '12am', '3am'];
    final zones = ['Zone A', 'Zone B', 'Zone C', 'Zone D', 'Zone E', 'Zone F'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GlassCard(
        glowColor: AppColors.glowPurple,
        glowIntensity: 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ride Demand Heatmap',
                    style: AppTypography.cardHeading(size: 18)),
                Text('Today',
                    style: AppTypography.label(color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Surge zones by hour',
                style: AppTypography.metadata(size: 12)),
            const SizedBox(height: 16),
            // Hour labels
            Row(
              children: [
                const SizedBox(width: 52),
                ...hours.map(
                  (h) => Expanded(
                    child: Text(h,
                        textAlign: TextAlign.center,
                        style: AppTypography.metadata(size: 9)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...List.generate(6, (row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(zones[row],
                          style: AppTypography.metadata(size: 10)),
                    ),
                    ...List.generate(8, (col) {
                      final intensity = _heatmap[row][col];
                      return Expanded(
                        child: Container(
                          height: 22,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: _heatColor(intensity),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            // Legend
            Row(
              children: [
                Text('Low', style: AppTypography.metadata(size: 10)),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.2),
                          AppColors.glowAmber,
                          AppColors.error,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text('High', style: AppTypography.metadata(size: 10)),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 450.ms)
          .slideY(begin: 0.2, end: 0, duration: 400.ms),
    );
  }

  Color _heatColor(double intensity) {
    if (intensity < 0.33) {
      return AppColors.primary.withOpacity(0.15 + intensity * 0.5);
    } else if (intensity < 0.66) {
      return AppColors.glowAmber.withOpacity(0.3 + intensity * 0.4);
    } else {
      return AppColors.error.withOpacity(0.4 + intensity * 0.5);
    }
  }
}
