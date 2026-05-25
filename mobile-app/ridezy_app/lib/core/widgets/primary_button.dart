import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';

/// Primary CTA button: glow pulse + press shrink + animated gradient
class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final List<Color>? gradientColors;
  final Color? glowColor;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final bool isLoading;

  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    this.gradientColors,
    this.glowColor,
    this.height = 60,
    this.borderRadius = 28,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.gradientColors ??
        [AppColors.primary, AppColors.secondary];
    final glow = widget.glowColor ?? AppColors.secondary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(colors: colors),
              boxShadow: [
                BoxShadow(
                  color: glow.withOpacity(_pulseAnim.value * 0.5),
                  blurRadius: 24 + (_pulseAnim.value * 12),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          widget.icon!,
                          const SizedBox(width: 10),
                        ],
                        Text(widget.label, style: AppTypography.button()),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary outlined button
class OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color? borderColor;
  final Color? textColor;
  final double height;

  const OutlineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.borderColor,
    this.textColor,
    this.height = 52,
  });

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final border = widget.borderColor ?? AppColors.primary;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border, width: 1.5),
            color: border.withOpacity(0.08),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: AppTypography.button(color: widget.textColor ?? border),
            ),
          ),
        ),
      ),
    );
  }
}
