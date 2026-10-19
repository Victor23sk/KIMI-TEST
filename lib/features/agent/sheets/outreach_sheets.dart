import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/apartment.dart';
import '../../../state/app_state.dart';

Future<void> showPriceOfferSheet(BuildContext context) async {
  final state = AppScope.read(context);
  final zhks = ApartmentPreview.catalog.map((a) => a.zhkName).toSet().toList();
  final selected = <String>{zhks.first};
  var price = 20.0;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              MediaQuery.paddingOf(ctx).bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Предложить свою цену', style: Theme.of(ctx).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('${price.round()} млн ₽', style: Theme.of(ctx).textTheme.titleLarge),
                Slider(
                  value: price,
                  min: 10,
                  max: 50,
                  divisions: 40,
                  label: '${price.round()}',
                  onChanged: (v) => setLocal(() => price = v),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: zhks.map((z) {
                    final on = selected.contains(z);
                    return FilterChip(
                      label: Text(z),
                      selected: on,
                      onSelected: (v) => setLocal(() {
                        if (v) {
                          selected.add(z);
                        } else {
                          selected.remove(z);
                        }
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () {
                          state.submitPriceOffer(
                            priceRub: (price * 1e6).round(),
                            zhkNames: selected.toList(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Предложение добавлено в историю')),
                          );
                        },
                  child: const Text('Отправить предложение'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> showMassOutreachSheet(BuildContext context) async {
  final state = AppScope.read(context);
  final zhks = ApartmentPreview.catalog.map((a) => a.zhkName).toSet().toList();
  final selected = <String>{...zhks.take(3)};
  var price = 22.0;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              MediaQuery.paddingOf(ctx).bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Массовая рассылка по ЖК', style: Theme.of(ctx).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Демо: заявки встают в очередь (без реальной отправки застройщикам)',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                Slider(
                  value: price,
                  min: 10,
                  max: 50,
                  divisions: 40,
                  label: '${price.round()} млн',
                  onChanged: (v) => setLocal(() => price = v),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: zhks.map((z) {
                    final on = selected.contains(z);
                    return FilterChip(
                      label: Text(z),
                      selected: on,
                      onSelected: (v) => setLocal(() {
                        if (v) {
                          selected.add(z);
                        } else {
                          selected.remove(z);
                        }
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () {
                          state.submitMassOutreach(
                            zhkNames: selected.toList(),
                            priceRub: (price * 1e6).round(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('В очереди: ${selected.length} ЖК'),
                            ),
                          );
                        },
                  child: const Text('Поставить в очередь'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
