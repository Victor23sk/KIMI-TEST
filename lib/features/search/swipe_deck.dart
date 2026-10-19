import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
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
    final cs = Theme.of(context).colorScheme;

    if (_deck.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 56, color: cs.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Колода пуста',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Уточните фильтры у агента или покажите карточки снова',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonal(
                onPressed: () => setState(() => _deck = List.of(ApartmentPreview.demos)),
                child: const Text('Показать снова'),
              ),
            ],
          ),
        ),
      );
    }

    final top = _deck.first;
    final maxCardWidth = MediaQuery.sizeOf(context).width >= 700 ? 420.0 : double.infinity;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
      child: Column(
        children: [
          Text(
            S.swipeHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCardWidth),
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => setState(() => _dragDx += d.delta.dx),
                  onHorizontalDragEnd: (_) {
                    if (_dragDx > 120) {
                      _like(top);
                    } else if (_dragDx < -120) {
                      _reject(top);
                    } else {
                      setState(() => _dragDx = 0);
                    }
                  },
                  onTap: () => context.push('/app/apartment/${top.id}'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 60),
                    curve: Curves.easeOut,
                    child: Transform.translate(
                      offset: Offset(_dragDx, 0),
                      child: Transform.rotate(
                        angle: _dragDx / 900,
                        child: ApartmentSwipeCard(apartment: top, dragDx: _dragDx),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundAction(
                icon: Icons.close_rounded,
                label: 'Нет',
                color: cs.error,
                bg: cs.errorContainer,
                onTap: () => _reject(top),
              ),
              const SizedBox(width: AppSpacing.xl),
              _RoundAction(
                icon: Icons.favorite_rounded,
                label: 'Да',
                color: cs.onPrimary,
                bg: cs.primary,
                large: true,
                onTap: () => _like(top),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 68.0 : 56.0;
    return Column(
      children: [
        Material(
          color: bg,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: color, size: large ? 30 : 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
