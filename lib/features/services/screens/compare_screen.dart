import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../state/app_state.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = AppScope.of(context).favorites.take(3).toList();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Сравнение избранного')),
      body: favs.length < 2
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Сохраните минимум 2 квартиры, чтобы сравнить',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: favs.map((a) {
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    child: SurfaceCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
                            child: Image.asset(a.zhkAsset, height: 120, fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.zhkName, style: Theme.of(context).textTheme.titleSmall),
                                Text(a.priceLabel),
                                Text('${a.areaM2} м²'),
                                Text(a.rooms == 0 ? 'студия' : '${a.rooms}-комн.'),
                                Text('эт. ${a.floor}'),
                                Text(a.district),
                                Text('метро ${a.metroMin} мин'),
                                Text(a.finishing),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
