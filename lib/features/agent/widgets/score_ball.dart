import 'package:flutter/material.dart';

/// Visual scoring ball = Traffic Quality Score (TQS 0–100).
class ScoreBall extends StatelessWidget {
  const ScoreBall({super.key, this.score, this.size = 88});

  /// Latest TQS; null only before first compute.
  final double? score;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final label = score == null ? '—' : score!.round().toString();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              cs.primary.withValues(alpha: 0.85),
              cs.primaryContainer,
              cs.tertiaryContainer.withValues(alpha: 0.9),
            ],
            stops: const [0.2, 0.65, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: cs.onPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
