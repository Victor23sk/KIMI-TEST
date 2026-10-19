import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';

class FeedPanel extends StatelessWidget {
  const FeedPanel({super.key});

  static const _items = [
    (S.bestOffers, Icons.local_fire_department_rounded, 'Подборка по вашим фильтрам', Color(0xFF0B5F5A)),
    (S.collections, Icons.collections_bookmark_rounded, 'Кураторские списки ЖК', Color(0xFF3D6B66)),
    (S.zhkDeepDive, Icons.apartment_rounded, 'Глубокий разбор проекта', Color(0xFF4A5C58)),
    (S.districtAnalytics, Icons.map_rounded, 'Цена, транспорт, спрос', Color(0xFF6B5A3D)),
    (S.designTrends, Icons.architecture_rounded, 'Архитектура и дизайн', Color(0xFF5A6B4A)),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
      itemCount: _items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final item = _items[i];
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: wide ? 720 : double.infinity),
            child: SurfaceCard(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.$1}: контент скоро')),
                );
              },
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.$4,
                          item.$4.withValues(alpha: 0.7),
                          cs.surfaceContainer,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    alignment: Alignment.bottomLeft,
                    child: Icon(item.$2, color: Colors.white.withValues(alpha: 0.9), size: 36),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
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
                        Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
