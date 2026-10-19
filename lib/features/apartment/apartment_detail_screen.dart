import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
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
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Material(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.grid_on_outlined,
                                size: 48, color: cs.onPrimaryContainer),
                            const SizedBox(height: 8),
                            Text(
                              'Планировка (заглушка)',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: cs.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    apartment.priceLabel,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${apartment.areaM2} ${S.m2} · этаж ${apartment.floor} · ${apartment.district}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _MatchBanner(percent: apartment.matchPercent),
                  const SizedBox(height: 20),
                  const _Section(
                    title: S.priceAnalytics,
                    body: 'Динамика цены и цена м² vs. соседи по ЖК — данные TBD.',
                  ),
                  const _Section(
                    title: S.transport,
                    body: 'Метро, МЦК/МЦД, авто — кэш аналитики TBD.',
                  ),
                  const _Section(
                    title: S.ecology,
                    body: 'Индекс экологии района — источник и дата обновления TBD.',
                  ),
                  const _Section(
                    title: S.crime,
                    body: 'Индикаторы безопасности — с дисклеймером; TBD.',
                  ),
                  const _Section(
                    title: S.schools,
                    body: 'Школы и детские сады в радиусе — POI TBD.',
                  ),
                  const _Section(
                    title: S.infrastructure,
                    body: 'Парки, клиники, ритейл — POI TBD.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${S.leaveLead} (заглушка) · шар оценки TBD'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_outlined),
                    label: const Text(S.leaveLead),
                  ),
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
    return Material(
      color: cs.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: 6,
                color: cs.primary,
                backgroundColor: cs.surface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
