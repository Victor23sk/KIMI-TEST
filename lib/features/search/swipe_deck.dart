import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../models/apartment.dart';
import 'apartment_swipe_card.dart';
import 'reject_reason_sheet.dart';

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({super.key});

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  late List<ApartmentPreview> _deck;
  double _dragDx = 0;

  @override
  void initState() {
    super.initState();
    _deck = List.of(ApartmentPreview.demos);
  }

  Future<void> _reject(ApartmentPreview apt) async {
    final reason = await showRejectReasonSheet(context);
    if (!mounted) return;
    setState(() {
      _deck.removeWhere((a) => a.id == apt.id);
      _dragDx = 0;
    });
    final label = reason ?? 'без причины';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Отклонено: $label')),
    );
  }

  void _like(ApartmentPreview apt) {
    setState(() {
      _deck.removeWhere((a) => a.id == apt.id);
      _dragDx = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Сохранено: ${apt.zhkName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_deck.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Колода пуста — уточните фильтры у агента',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => setState(() => _deck = List.of(ApartmentPreview.demos)),
              child: const Text('Показать снова'),
            ),
          ],
        ),
      );
    }

    final top = _deck.first;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          Text(
            S.swipeHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (d) => setState(() => _dragDx += d.delta.dx),
              onHorizontalDragEnd: (d) {
                if (_dragDx > 120) {
                  _like(top);
                } else if (_dragDx < -120) {
                  _reject(top);
                } else {
                  setState(() => _dragDx = 0);
                }
              },
              onTap: () => context.push('/app/apartment/${top.id}'),
              child: Transform.translate(
                offset: Offset(_dragDx, 0),
                child: Transform.rotate(
                  angle: _dragDx / 800,
                  child: ApartmentSwipeCard(
                    apartment: top,
                    dragDx: _dragDx,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _reject(top),
                icon: const Icon(Icons.close),
                label: const Text('Нет'),
                style: FilledButton.styleFrom(
                  foregroundColor: cs.error,
                ),
              ),
              FilledButton.icon(
                onPressed: () => _like(top),
                icon: const Icon(Icons.favorite_outline),
                label: const Text('Да'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
