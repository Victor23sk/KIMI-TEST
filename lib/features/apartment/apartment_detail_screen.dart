import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';
import '../../models/apartment.dart';

class ApartmentDetailScreen extends StatelessWidget {
  const ApartmentDetailScreen({super.key, required this.apartment});

  final ApartmentPreview apartment;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(apartment.zhkName),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Material(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomPaint(
                            painter: _DetailPlanPainter(
                              wall: cs.onPrimaryContainer.withValues(alpha: 0.4),
                              fill: cs.surface.withValues(alpha: 0.3),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: cs.surface.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(AppRadii.sm),
                              ),
                              child: Text(
                                'Планировка · заглушка',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(apartment.priceLabel, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${apartment.areaM2} ${S.m2} · этаж ${apartment.floor} · ${apartment.district}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _MatchBanner(percent: apartment.matchPercent),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Аналитика', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  _AnalyticsTile(
                    icon: Icons.price_change_outlined,
                    title: S.priceAnalytics,
                    body: 'Динамика цены и цена м² vs. соседи по ЖК — данные скоро.',
                  ),
                  _AnalyticsTile(
                    icon: Icons.directions_subway_outlined,
                    title: S.transport,
                    body: 'Метро, МЦК/МЦД, авто — кэш аналитики.',
                  ),
                  _AnalyticsTile(
                    icon: Icons.park_outlined,
                    title: S.ecology,
                    body: 'Индекс экологии района — источник и дата обновления.',
                  ),
                  _AnalyticsTile(
                    icon: Icons.shield_outlined,
                    title: S.crime,
                    body: 'Индикаторы безопасности — с дисклеймером.',
                  ),
                  _AnalyticsTile(
                    icon: Icons.school_outlined,
                    title: S.schools,
                    body: 'Школы и детские сады в радиусе.',
                  ),
                  _AnalyticsTile(
                    icon: Icons.storefront_outlined,
                    title: S.infrastructure,
                    body: 'Парки, клиники, ритейл.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${S.leaveLead} · TQS маршрутизация по бандам',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded),
                    label: const Text(S.leaveLead),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchBanner extends StatelessWidget {
  const _MatchBanner({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      color: cs.secondaryContainer,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.matchPercent,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: cs.onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 7,
                  color: cs.primary,
                  backgroundColor: cs.surface.withValues(alpha: 0.45),
                ),
                Text(
                  '$percent',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: cs.onSecondaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsTile extends StatelessWidget {
  const _AnalyticsTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SurfaceCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.35,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Local plan painter for detail (avoids exporting private painter).
class _DetailPlanPainter extends CustomPainter {
  _DetailPlanPainter({required this.wall, required this.fill});

  final Color wall;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = wall
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final inset = size.shortestSide * 0.12;
    final rect = Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2);
    final r = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(r, fillPaint);
    canvas.drawRRect(r, paint);
    canvas.drawLine(Offset(rect.left + rect.width * 0.4, rect.top), Offset(rect.left + rect.width * 0.4, rect.bottom), paint);
    canvas.drawLine(Offset(rect.left, rect.top + rect.height * 0.55), Offset(rect.left + rect.width * 0.4, rect.top + rect.height * 0.55), paint);
  }

  @override
  bool shouldRepaint(covariant _DetailPlanPainter oldDelegate) => false;
}
