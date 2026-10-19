import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';

class FeedPanel extends StatelessWidget {
  const FeedPanel({super.key});

  static const _items = [
    (S.bestOffers, Icons.local_fire_department_outlined, 'Подборка по вашим фильтрам — заглушка'),
    (S.collections, Icons.collections_bookmark_outlined, 'Кураторские списки ЖК'),
    (S.zhkDeepDive, Icons.apartment_outlined, 'Глубокий разбор проекта'),
    (S.districtAnalytics, Icons.map_outlined, 'Цена, транспорт, спрос по району'),
    (S.designTrends, Icons.architecture_outlined, 'Архитектура и дизайн новостроек'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = _items[i];
        return Material(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.$1}: контент скоро')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Icon(item.$2, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          item.$3,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
