// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/role_selector.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String _role = 'Rider';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // Show connecting overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ConnectingOverlay(),
    );
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pop(); // close overlay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelector()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Heading
                Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (r) => AppColors.gradientPrimary
                          .createShader(
                              Rect.fromLTWH(0, 0, r.width, r.height)),
                      child: Text('Create your\nRidezy Identity',
                          textAlign: TextAlign.center,
                          style: AppTypography.heroTitle(size: 34)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Blockchain-secured mobility for the future',
                      textAlign: TextAlign.center,
                      style: AppTypography.description(
                          size: 14,
                          color: Colors.white.withOpacity(0.65)),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),

                const SizedBox(height: 28),

                // Form card
                GlassCard(
                  glowColor: AppColors.glowCyan,
                  glowIntensity: 0.14,
                  borderRadius: 28,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColors.glowGreen,
                              AppColors.glowCyan
                            ]),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _AuthField(
                          controller: _nameCtrl,
                          label: 'Full Name',
                          hint: 'Arjun Singh',
                          icon: Icons.badge_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        _AuthField(
                          controller: _emailCtrl,
                          label: 'Email Address',
                          hint: 'you@example.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              (v == null || !v.contains('@'))
                                  ? 'Valid email required'
                                  : null,
                        ),
                        const SizedBox(height: 14),

                        _AuthField(
                          controller: _phoneCtrl,
                          label: 'Mobile Number',
                          hint: '+91 98765 43210',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              (v == null || v.length < 10)
                                  ? 'Valid number required'
                                  : null,
                        ),
                        const SizedBox(height: 14),

                        _AuthField(
                          controller: _passCtrl,
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscure,
                          suffix: GestureDetector(
                            onTap: () =>
                                setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 18),

                        // Role selector
                        Text('Choose Experience',
                            style: AppTypography.label(size: 12)),
                        const SizedBox(height: 8),
                        Row(
                          children: ['Rider', 'Driver', 'Fleet Partner']
                              .map((r) => Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _role = r),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                            milliseconds: 250),
                                        margin: const EdgeInsets.only(
                                            right: 8),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: _role == r
                                              ? AppColors.primary
                                                  .withOpacity(0.3)
                                              : Colors.white
                                                  .withOpacity(0.05),
                                          border: Border.all(
                                            color: _role == r
                                                ? AppColors.primary
                                                : Colors.white
                                                    .withOpacity(0.1),
                                            width: _role == r ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Text(
                                          r,
                                          textAlign: TextAlign.center,
                                          style: AppTypography.label(
                                            size: 11,
                                            color: _role == r
                                                ? AppColors.textPrimary
                                                : AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        GlowButton(
                          label: 'Create Identity',
                          height: 54,
                          isLoading: _loading,
                          gradientColors: [
                            AppColors.glowGreen.withOpacity(0.8),
                            AppColors.glowCyan,
                          ],
                          glowColor: AppColors.glowGreen,
                          onTap: _submit,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),

                const SizedBox(height: 16),

                // AI Trust panel
                GlassCard(
                  glowColor: AppColors.glowGreen,
                  glowIntensity: 0.10,
                  borderRadius: 20,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.glowGreen.withOpacity(0.08),
                      AppColors.glowCyan.withOpacity(0.04),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_user_rounded,
                              color: AppColors.glowGreen, size: 16),
                          const SizedBox(width: 8),
                          Text('AI Trust Verification',
                              style: AppTypography.label(
                                  size: 13,
                                  color: AppColors.glowGreen)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _TrustRow(
                        icon: Icons.psychology_rounded,
                        color: AppColors.glowPurple,
                        label: 'AI Safety Monitoring',
                        desc: 'Real-time computer vision on every ride',
                      ),
                      const SizedBox(height: 8),
                      _TrustRow(
                        icon: Icons.lock_rounded,
                        color: AppColors.glowCyan,
                        label: 'Blockchain Escrow Protection',
                        desc: 'Smart contract secured payments',
                      ),
                      const SizedBox(height: 8),
                      _TrustRow(
                        icon: Icons.fingerprint_rounded,
                        color: AppColors.glowGreen,
                        label: 'Decentralized Identity',
                        desc: 'On-chain credibility verification',
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an identity? ',
                        style: AppTypography.description(size: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      ),
                      child: Text('Sign In',
                          style: AppTypography.label(
                              size: 13, color: AppColors.glowCyan)),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String desc;
  const _TrustRow(
      {required this.icon,
      required this.color,
      required this.label,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.label(
                      size: 12, color: AppColors.textPrimary)),
              Text(desc,
                  style: AppTypography.metadata(
                      size: 11,
                      color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
        Icon(Icons.check_circle_rounded, color: color, size: 14),
      ],
    );
  }
}

// Shared _AuthField (same as login_screen but local)
class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label(size: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.description(
              size: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.description(
                size: 14, color: AppColors.textMuted),
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                  color: AppColors.glowCyan, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

/// Connecting to decentralized networks loading overlay
class _ConnectingOverlay extends StatefulWidget {
  const _ConnectingOverlay();

  @override
  State<_ConnectingOverlay> createState() => _ConnectingOverlayState();
}

class _ConnectingOverlayState extends State<_ConnectingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _step = 0;
  Timer? _timer;

  final _steps = [
    'Connecting to decentralized mobility networks...',
    'Verifying blockchain identity...',
    'Initializing AI safety profile...',
    'Identity secured on Polygon ✓',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted && _step < _steps.length - 1) {
        setState(() => _step++);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        glowColor: AppColors.glowCyan,
        glowIntensity: 0.25,
        borderRadius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPrimary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.glowCyan.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowCyan
                          .withOpacity(0.2 + _ctrl.value * 0.3),
                      blurRadius: 16 + _ctrl.value * 12,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.glowCyan,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                _steps[_step],
                key: ValueKey(_step),
                textAlign: TextAlign.center,
                style: AppTypography.description(
                    size: 14, color: Colors.white.withOpacity(0.85)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
