// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/primary_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthGateway extends StatefulWidget {
  const AuthGateway({super.key});

  @override
  State<AuthGateway> createState() => _AuthGatewayState();
}

class _AuthGatewayState extends State<AuthGateway>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── TOP: Logo + heading ──────────────────────────────
              Expanded(
                flex: 4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated AI glow logo
                      AnimatedBuilder(
                        animation: _glowCtrl,
                        builder: (_, child) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.glowCyan.withOpacity(
                                    0.30 + _glowCtrl.value * 0.40),
                                blurRadius: 40 + _glowCtrl.value * 20,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.glowPurple.withOpacity(
                                    0.15 + _glowCtrl.value * 0.15),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: child,
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.4),
                                border: Border.all(
                                  color: AppColors.glowCyan.withOpacity(0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/ridezy_logo.png',
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 900.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 24),

                      ShaderMask(
                        shaderCallback: (r) => AppColors.gradientPrimary
                            .createShader(
                                Rect.fromLTWH(0, 0, r.width, r.height)),
                        child: Text(
                          'Access the Future\nof Mobility',
                          textAlign: TextAlign.center,
                          style: AppTypography.heroTitle(size: 36),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms),

                      const SizedBox(height: 10),

                      Text(
                        'AI-secured · Blockchain-verified · Decentralized',
                        style: AppTypography.metadata(
                            size: 12,
                            color: AppColors.glowCyan.withOpacity(0.8)),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 500.ms),
                    ],
                  ),
                ),
              ),

              // ── MIDDLE: Glassmorphic auth card ───────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  glowColor: AppColors.glowPurple,
                  glowIntensity: 0.18,
                  borderRadius: 28,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.09),
                      Colors.white.withOpacity(0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    children: [
                      // AI mesh accent line
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientPrimary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Choose Your Access',
                        style: AppTypography.cardHeading(size: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in or create your decentralized identity',
                        style: AppTypography.description(
                            size: 13,
                            color: Colors.white.withOpacity(0.65)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      GlowButton(
                        label: 'Sign In',
                        height: 54,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlowButton(
                        label: 'Create Identity',
                        height: 54,
                        gradientColors: [
                          AppColors.glowGreen.withOpacity(0.7),
                          AppColors.glowCyan,
                        ],
                        glowColor: AppColors.glowGreen,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(children: [
                        Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or continue with',
                              style: AppTypography.metadata(size: 11)),
                        ),
                        Expanded(
                            child: Divider(
                                color: Colors.white.withOpacity(0.1))),
                      ]),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                              child: _SocialBtn(
                                  label: 'Google',
                                  icon: Icons.g_mobiledata_rounded,
                                  color: const Color(0xFFEA4335))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _SocialBtn(
                                  label: 'Apple',
                                  icon: Icons.apple_rounded,
                                  color: Colors.white)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _SocialBtn(
                                  label: 'Wallet',
                                  icon: Icons.account_balance_wallet_rounded,
                                  color: AppColors.glowPurple)),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideY(begin: 0.25, end: 0, duration: 500.ms),
              ),

              // ── BOTTOM: Trust badges ─────────────────────────────
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 24,
                  right: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TrustBadge(
                        icon: Icons.link_rounded,
                        label: 'Blockchain\nSecured'),
                    _TrustBadge(
                        icon: Icons.shield_rounded,
                        label: 'AI\nProtected'),
                    _TrustBadge(
                        icon: Icons.hub_rounded,
                        label: 'Decentralized\nMobility'),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _SocialBtn(
      {required this.label, required this.icon, required this.color});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 18),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: AppTypography.label(
                      size: 12, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glowCyan.withOpacity(0.08),
            border: Border.all(
                color: AppColors.glowCyan.withOpacity(0.2), width: 1),
          ),
          child: Icon(icon, color: AppColors.glowCyan, size: 16),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.metadata(
              size: 10, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
}
