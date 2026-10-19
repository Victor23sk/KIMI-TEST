import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../models/apartment.dart';

/// Swipe card: floor-plan hero, price, area, ЖК name.
class ApartmentSwipeCard extends StatelessWidget {
  const ApartmentSwipeCard({
    super.key,
    required this.apartment,
    this.dragDx = 0,
  });

  final ApartmentPreview apartment;
  final double dragDx;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final likeOpacity = (dragDx / 120).clamp(0.0, 1.0);
    final nopeOpacity = (-dragDx / 120).clamp(0.0, 1.0);

    return Material(
      elevation: 1,
      shadowColor: cs.shadow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      color: cs.surfaceContainerLow,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Floor plan as dominant visual plane (placeholder pattern).
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primaryContainer,
                  cs.surfaceContainerHighest,
                  cs.tertiaryContainer.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: CustomPaint(
              painter: _FloorPlanPainter(color: cs.onPrimaryContainer.withValues(alpha: 0.35)),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Opacity(
              opacity: likeOpacity,
              child: _Stamp(label: 'СОХРАНИТЬ', color: cs.primary),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: nopeOpacity,
              child: _Stamp(label: 'НЕТ', color: cs.error),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    cs.surface.withValues(alpha: 0.92),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apartment.zhkName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${apartment.priceLabel} · ${apartment.areaM2} ${S.m2} · '
                      '${apartment.rooms == 0 ? 'студия' : '${apartment.rooms}-комн.'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${S.matchPercent}: ${apartment.matchPercent}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: cs.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final inset = size.shortestSide * 0.12;
    final rect = Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height * 0.55);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

    // Inner partitions — schematic plan.
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.4, rect.top),
      Offset(rect.left + rect.width * 0.4, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top + rect.height * 0.55),
      Offset(rect.left + rect.width * 0.4, rect.top + rect.height * 0.55),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.4, rect.top + rect.height * 0.35),
      Offset(rect.right, rect.top + rect.height * 0.35),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FloorPlanPainter oldDelegate) =>
      oldDelegate.color != color;
}
