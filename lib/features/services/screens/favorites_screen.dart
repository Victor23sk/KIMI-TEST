import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../state/app_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = AppScope.of(context).favorites;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: favs.isEmpty
          ? Center(
              child: Text(
                'Пока пусто — сохраните карточки свайпом вправо',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: favs.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final a = favs[i];
                return SurfaceCard(
                  padding: EdgeInsets.zero,
                  onTap: () => context.push('/app/apartment/${a.id}'),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadii.lg)),
                        child: Image.asset(
                          a.planAsset,
                          width: 110,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.zhkName, style: Theme.of(context).textTheme.titleSmall),
                              Text(a.priceLabel, style: Theme.of(context).textTheme.titleMedium),
                              Text('${a.areaM2} м² · ${a.district}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
