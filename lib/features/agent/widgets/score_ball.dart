import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Scoring ball = Traffic Quality Score (TQS 0–100).
class ScoreBall extends StatelessWidget {
  const ScoreBall({
    super.key,
    this.score,
    this.size = 104,
    this.bandLabel,
  });

  final double? score;
  final double size;
  final String? bandLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = score ?? 0;
    final label = score == null ? '—' : score!.round().toString();
    final band = bandLabel ?? _band(score);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  progress: progress,
                  track: cs.surfaceContainerHighest,
                  fill: cs.primary,
                  glow: cs.primary.withValues(alpha: 0.2),
                ),
              ),
              Container(
                width: size * 0.72,
                height: size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      cs.primary.withValues(alpha: 0.92),
                      cs.primaryContainer,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      band,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: cs.onPrimary.withValues(alpha: 0.85),
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _band(double? score) {
    if (score == null) return '—';
    if (score >= 80) return 'горячий';
    if (score >= 50) return 'тёплый';
    if (score >= 25) return 'карантин';
    return 'слабый';
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
    required this.glow,
  });

  final double progress;
  final Color track;
  final Color fill;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class RaiseScoreActions extends StatelessWidget {
  const RaiseScoreActions({super.key, required this.actions});

  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: actions.map((a) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.arrow_outward_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  a,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
