import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../models/apartment.dart';

class ApartmentSwipeCard extends StatelessWidget {
  const ApartmentSwipeCard({
    super.key,
    required this.apartment,
    required this.matchPercent,
    this.dragDx = 0,
  });

  final ApartmentPreview apartment;
  final int matchPercent;
  final double dragDx;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final likeOpacity = (dragDx / 120).clamp(0.0, 1.0);
    final nopeOpacity = (-dragDx / 120).clamp(0.0, 1.0);

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadii.xl),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Floor plan as dominant hero.
            Image.asset(
              apartment.planAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ColoredBox(color: cs.primaryContainer),
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
                    color: cs.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Text('Планировка', style: Theme.of(context).textTheme.labelLarge),
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
                      cs.surface.withValues(alpha: 0.97),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
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
                          '${S.matchPercent}: $matchPercent%',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: cs.onPrimaryContainer,
                              ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(apartment.zhkName, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(
                        apartment.priceLabel,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: cs.primary),
                      ),
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
          color: color.withValues(alpha: 0.1),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}
