// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/vehicle_approaching_widget.dart';

enum RideStage {
  booking,
  aiSearching,
  driverAssigned,
  vehicleApproaching,
  liveTracking,
  aiSafetyMonitoring,
  rideComplete,
  blockchainPayment,
}

class _StageConfig {
  final String title;
  final String subtitle;
  final String detail;
  final IconData icon;
  final Color color;
  final String? lottie;

  const _StageConfig({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.icon,
    required this.color,
    this.lottie,
  });
}

const _stages = <RideStage, _StageConfig>{
  RideStage.booking: _StageConfig(
    title: 'Booking Ride',
    subtitle: 'Confirming your request...',
    detail: 'Securing your ride with smart contract escrow',
    icon: Icons.hail_rounded,
    color: AppColors.glowPurple,
  ),
  RideStage.aiSearching: _StageConfig(
    title: 'AI Searching',
    subtitle: 'Finding the best driver for you',
    detail: 'Matching by proximity, credibility score & AI safety rating',
    icon: Icons.psychology_rounded,
    color: AppColors.glowCyan,
    lottie: 'assets/lottie/loading.json',
  ),
  RideStage.driverAssigned: _StageConfig(
    title: 'Driver Assigned',
    subtitle: 'Arjun Singh is on his way',
    detail: 'Credibility Score: 4.92 · AI Safety: 96/100 · 847 rides',
    icon: Icons.person_pin_circle_rounded,
    color: AppColors.glowGreen,
  ),
  RideStage.vehicleApproaching: _StageConfig(
    title: 'Vehicle Approaching',
    subtitle: 'Tesla Model 3 · MH 01 AB 1234',
    detail: 'ETA 3 min · 0.8 km away · AI monitoring active',
    icon: Icons.electric_car_rounded,
    color: AppColors.glowAmber,
  ),
  RideStage.liveTracking: _StageConfig(
    title: 'Live Tracking',
    subtitle: 'Ride in progress',
    detail: '4.2 km remaining · ETA 8 min · ₹340',
    icon: Icons.route_rounded,
    color: AppColors.glowCyan,
    lottie: 'assets/lottie/2 points map route.json',
  ),
  RideStage.aiSafetyMonitoring: _StageConfig(
    title: 'AI Safety Active',
    subtitle: 'Computer vision monitoring your ride',
    detail: 'Lane detection · Speed compliance · Distraction alerts',
    icon: Icons.shield_rounded,
    color: AppColors.glowGreen,
  ),
  RideStage.rideComplete: _StageConfig(
    title: 'Ride Complete!',
    subtitle: 'You\'ve arrived safely',
    detail: 'Total: ₹340 · 4.2 km · 12 min · AI Score: 98/100',
    icon: Icons.check_circle_rounded,
    color: AppColors.glowGreen,
    lottie: 'assets/lottie/Successful Payment.json',
  ),
  RideStage.blockchainPayment: _StageConfig(
    title: 'Blockchain Secured',
    subtitle: 'Payment processed on-chain',
    detail: 'Escrow released · Credibility updated · NFT receipt minted',
    icon: Icons.verified_rounded,
    color: AppColors.glowPurple,
    lottie: 'assets/lottie/Successful Payment.json',
  ),
};

class RideLifecycleScreen extends StatefulWidget {
  const RideLifecycleScreen({super.key});

  @override
  State<RideLifecycleScreen> createState() => _RideLifecycleScreenState();
}

class _RideLifecycleScreenState extends State<RideLifecycleScreen>
    with TickerProviderStateMixin {
  RideStage _stage = RideStage.booking;
  Timer? _autoTimer;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  final _stageOrder = RideStage.values;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final idx = _stageOrder.indexOf(_stage);
      if (idx < _stageOrder.length - 1) {
        _advanceTo(_stageOrder[idx + 1]);
      } else {
        _autoTimer?.cancel();
      }
    });
  }

  void _advanceTo(RideStage next) {
    setState(() => _stage = next);
    _progressController.forward(from: 0);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  double get _progress {
    final idx = _stageOrder.indexOf(_stage);
    return (idx + 1) / _stageOrder.length;
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _stages[_stage]!;
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildProgressBar(),
              Expanded(child: _buildStageContent(cfg)),
              _buildStageTimeline(),
              _buildBottomActions(cfg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: GlassCard(
              padding: const EdgeInsets.all(10),
              borderRadius: 14,
              child: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary, size: 16),
            ),
          ),
          const SizedBox(width: 14),
          Text('Ride Journey', style: AppTypography.cardHeading(size: 18)),
          const Spacer(),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            borderRadius: 14,
            glowColor: AppColors.error,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sos_rounded, color: AppColors.error, size: 16),
                const SizedBox(width: 6),
                Text('SOS', style: AppTypography.label(size: 12, color: AppColors.error)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_stageOrder.indexOf(_stage) + 1} of ${_stageOrder.length}',
                style: AppTypography.metadata(size: 12),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTypography.label(
                    size: 12, color: _stages[_stage]!.color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 6,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation(_stages[_stage]!.color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageContent(_StageConfig cfg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: GlassCard(
        glowColor: cfg.color,
        glowIntensity: 0.25,
        gradient: LinearGradient(
          colors: [
            cfg.color.withOpacity(0.14),
            cfg.color.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Lottie
            if (cfg.lottie != null)
              SizedBox(
                width: 140,
                height: 140,
                child: Lottie.asset(cfg.lottie!, repeat: true, animate: true),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  )
            else
              AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cfg.color.withOpacity(0.12),
                    boxShadow: [
                      BoxShadow(
                        color: cfg.color.withOpacity(
                            0.2 + _pulseController.value * 0.3),
                        blurRadius: 24 + _pulseController.value * 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(cfg.icon, color: cfg.color, size: 44),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.7, 0.7),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

            const SizedBox(height: 24),

            Text(cfg.title, style: AppTypography.sectionTitle(size: 28))
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms),

            const SizedBox(height: 8),

            Text(cfg.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.cardHeading(
                    size: 16, color: cfg.color))
                .animate()
                .fadeIn(duration: 400.ms, delay: 150.ms),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Text(
                cfg.detail,
                textAlign: TextAlign.center,
                style: AppTypography.description(size: 13),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.1, end: 0, duration: 400.ms),

            // Stage-specific extras
            const SizedBox(height: 16),
            _buildStageExtras(),
          ],
        ),
      ).animate(key: ValueKey(_stage)).fadeIn(duration: 350.ms).slideY(
            begin: 0.15,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildStageExtras() {
    switch (_stage) {
      case RideStage.vehicleApproaching:
        return const VehicleApproachingWidget();
      case RideStage.driverAssigned:
        return _driverCard();
      case RideStage.aiSafetyMonitoring:
        return _aiMetricsRow();
      case RideStage.blockchainPayment:
        return _blockchainReceipt();
      case RideStage.rideComplete:
        return _ratingRow();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _driverCard() {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      glowColor: AppColors.glowGreen,
      glowIntensity: 0.1,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradientPrimary,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Arjun Singh', style: AppTypography.cardHeading(size: 15)),
              Text('Tesla Model 3 · MH 01 AB 1234',
                  style: AppTypography.metadata(size: 11)),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.glowAmber, size: 16),
              Text('4.92',
                  style: AppTypography.label(
                      size: 12, color: AppColors.glowAmber)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aiMetricsRow() {
    final metrics = [
      ('Lane', '✓', AppColors.glowGreen),
      ('Speed', '98%', AppColors.glowCyan),
      ('Alert', '✓', AppColors.glowGreen),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: metrics.map((m) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: m.$3.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Text(m.$2,
                  style: AppTypography.label(size: 14, color: m.$3)),
            ),
            const SizedBox(height: 4),
            Text(m.$1, style: AppTypography.metadata(size: 11)),
          ],
        );
      }).toList(),
    );
  }

  Widget _blockchainReceipt() {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      glowColor: AppColors.glowPurple,
      glowIntensity: 0.12,
      child: Column(
        children: [
          _receiptRow('Tx Hash', '0x4f2a...c91b'),
          const SizedBox(height: 6),
          _receiptRow('Block', '#18,432,901'),
          const SizedBox(height: 6),
          _receiptRow('Network', 'Polygon'),
          const SizedBox(height: 6),
          _receiptRow('Status', '✓ Confirmed'),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.metadata(size: 11)),
        Text(value,
            style: AppTypography.label(
                size: 11, color: AppColors.glowPurple)),
      ],
    );
  }

  Widget _ratingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (i) => Icon(Icons.star_rounded,
                color: i < 5 ? AppColors.glowAmber : AppColors.textMuted,
                size: 32)
            .animate(delay: (i * 80).ms)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 300.ms,
              curve: Curves.elasticOut,
            ),
      ),
    );
  }

  Widget _buildStageTimeline() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _stageOrder.length,
        itemBuilder: (_, i) {
          final s = _stageOrder[i];
          final cfg = _stages[s]!;
          final currentIdx = _stageOrder.indexOf(_stage);
          final isDone = i < currentIdx;
          final isCurrent = i == currentIdx;

          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? cfg.color.withOpacity(0.3)
                      : isCurrent
                          ? cfg.color.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: isCurrent
                        ? cfg.color
                        : isDone
                            ? cfg.color.withOpacity(0.5)
                            : Colors.white.withOpacity(0.1),
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : cfg.icon,
                  size: 16,
                  color: isCurrent || isDone
                      ? cfg.color
                      : AppColors.textMuted,
                ),
              ),
              if (i < _stageOrder.length - 1)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 20,
                  height: 2,
                  color: isDone
                      ? cfg.color.withOpacity(0.4)
                      : Colors.white.withOpacity(0.08),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomActions(_StageConfig cfg) {
    final idx = _stageOrder.indexOf(_stage);
    final isLast = idx == _stageOrder.length - 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
      child: isLast
          ? GlowButton(
              label: 'Back to Home',
              height: 56,
              gradientColors: [AppColors.primary, AppColors.secondary],
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            )
          : Row(
              children: [
                Expanded(
                  child: GlowButton(
                    label: idx == _stageOrder.length - 2
                        ? 'Finish'
                        : 'Next Stage',
                    height: 52,
                    gradientColors: [cfg.color.withOpacity(0.8), cfg.color],
                    glowColor: cfg.color,
                    onTap: () {
                      _autoTimer?.cancel();
                      _advanceTo(_stageOrder[idx + 1]);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                GlassCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 16,
                  child: const Icon(Icons.phone_rounded,
                      color: AppColors.glowGreen, size: 22),
                ),
              ],
            ),
    );
  }
}
