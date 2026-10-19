import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';
import '../../models/apartment.dart';
import '../../state/app_state.dart';

class ApartmentDetailScreen extends StatelessWidget {
  const ApartmentDetailScreen({super.key, required this.apartment});

  final ApartmentPreview apartment;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final match = state.active.matchPercent(apartment);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(apartment.zhkName),
            actions: [
              IconButton(
                icon: Icon(
                  state.favoriteIds.contains(apartment.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                onPressed: () => state.like(apartment),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(
                        apartment.planAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(color: cs.primaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        apartment.zhkAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(color: cs.secondaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Планировка · фасад ЖК',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(apartment.priceLabel, style: Theme.of(context).textTheme.headlineMedium),
                  Text(
                    '${apartment.areaM2} ${S.m2} · этаж ${apartment.floor} · ${apartment.district} · метро ${apartment.metroMin} мин',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SurfaceCard(
                    color: cs.secondaryContainer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.matchPercent, style: Theme.of(context).textTheme.titleSmall),
                              Text('$match%', style: Theme.of(context).textTheme.headlineMedium),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: match / 100,
                            strokeWidth: 7,
                            color: cs.primary,
                            backgroundColor: cs.surface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Аналитика', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  _Tile(Icons.price_change_outlined, S.priceAnalytics, 'Цена м² и динамика — демо-заглушка'),
                  _Tile(Icons.directions_subway_outlined, S.transport, 'Метро ${apartment.metroMin} мин · МЦК рядом'),
                  _Tile(Icons.park_outlined, S.ecology, 'Индекс экологии района — демо'),
                  _Tile(Icons.shield_outlined, S.crime, 'Безопасность — с дисклеймером'),
                  _Tile(Icons.school_outlined, S.schools, 'Школы и сады в радиусе 1 км'),
                  _Tile(Icons.storefront_outlined, S.infrastructure, 'Ритейл, клиники, парки'),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: () {
                      state.leaveLead(apartment);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${S.leaveLead}: TQS ${state.tqs.round()} (${state.tqsBand})',
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

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.body);
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
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
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
                  Text(body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
