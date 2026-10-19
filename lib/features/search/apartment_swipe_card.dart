import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
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
      elevation: 0,
      borderRadius: BorderRadius.circular(AppRadii.xl),
      clipBehavior: Clip.antiAlias,
      color: cs.surfaceContainerLowest,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.primaryContainer,
                    cs.surfaceContainer,
                    cs.tertiaryContainer.withValues(alpha: 0.55),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: _FloorPlanPainter(
                  wall: cs.onPrimaryContainer.withValues(alpha: 0.45),
                  fill: cs.surface.withValues(alpha: 0.35),
                ),
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
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Text(
                    'Планировка',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ),
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
                      cs.surface.withValues(alpha: 0.96),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                        child: Text(
                          '${S.matchPercent}: ${apartment.matchPercent}%',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: cs.onPrimaryContainer,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        apartment.zhkName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        apartment.priceLabel,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: cs.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${apartment.areaM2} ${S.m2} · '
                        '${apartment.rooms == 0 ? 'студия' : '${apartment.rooms}-комн.'} · '
                        'эт. ${apartment.floor} · ${apartment.district}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return Transform.rotate(
      angle: label == 'НЕТ' ? 0.2 : -0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2.5),
          borderRadius: BorderRadius.circular(AppRadii.sm),
          color: color.withValues(alpha: 0.08),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
        ),
      ),
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  _FloorPlanPainter({required this.wall, required this.fill});

  final Color wall;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = wall
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;

    final insetX = size.width * 0.14;
    final insetY = size.height * 0.12;
    final rect = Rect.fromLTWH(
      insetX,
      insetY,
      size.width - insetX * 2,
      size.height * 0.48,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, paint);

    // Rooms
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.42, rect.top),
      Offset(rect.left + rect.width * 0.42, rect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top + rect.height * 0.52),
      Offset(rect.left + rect.width * 0.42, rect.top + rect.height * 0.52),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.42, rect.top + rect.height * 0.38),
      Offset(rect.right, rect.top + rect.height * 0.38),
      paint,
    );
    // Door gaps suggestion
    final door = Paint()
      ..color = wall.withValues(alpha: 0.35)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(rect.left + rect.width * 0.42, rect.top + rect.height * 0.62),
      Offset(rect.left + rect.width * 0.42, rect.top + rect.height * 0.78),
      door,
    );
  }

  @override
  bool shouldRepaint(covariant _FloorPlanPainter oldDelegate) =>
      oldDelegate.wall != wall || oldDelegate.fill != fill;
}
