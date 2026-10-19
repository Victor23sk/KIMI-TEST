import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../state/app_state.dart';
import 'apartment_swipe_card.dart';
import 'reject_reason_sheet.dart';

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({super.key});

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> {
  double _dragDx = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final session = state.active;
    final deck = session.filteredCatalog();
    final cs = Theme.of(context).colorScheme;

    if (deck.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.filter_alt_off_outlined, size: 48, color: cs.primary),
              const SizedBox(height: 12),
              Text('Нет лотов под фильтры', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Ослабьте бюджет/комнаты у агента или очистите отклонения',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final top = deck.first;
    final match = session.matchPercent(top);
    final maxW = MediaQuery.sizeOf(context).width >= 700 ? 420.0 : double.infinity;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.lg),
      child: Column(
        children: [
          Text(
            '${S.swipeHint} · ${session.title} · ${deck.length} в колоде',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => setState(() => _dragDx += d.delta.dx),
                  onHorizontalDragEnd: (_) async {
                    if (_dragDx > 120) {
                      state.like(top);
                      setState(() => _dragDx = 0);
                    } else if (_dragDx < -120) {
                      final reason = await showRejectReasonSheet(context);
                      if (!context.mounted) return;
                      state.dislike(top, reason: reason);
                      setState(() => _dragDx = 0);
                    } else {
                      setState(() => _dragDx = 0);
                    }
                  },
                  onTap: () {
                    state.viewDetail(top);
                    context.push('/app/apartment/${top.id}');
                  },
                  child: Transform.translate(
                    offset: Offset(_dragDx, 0),
                    child: Transform.rotate(
                      angle: _dragDx / 900,
                      child: ApartmentSwipeCard(
                        apartment: top,
                        matchPercent: match,
                        dragDx: _dragDx,
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
              _Round(
                icon: Icons.close_rounded,
                label: 'Нет',
                bg: cs.errorContainer,
                fg: cs.error,
                onTap: () async {
                  final reason = await showRejectReasonSheet(context);
                  if (!context.mounted) return;
                  state.dislike(top, reason: reason);
                  setState(() => _dragDx = 0);
                },
              ),
              const SizedBox(width: AppSpacing.xl),
              _Round(
                icon: Icons.favorite_rounded,
                label: 'Да',
                bg: cs.primary,
                fg: cs.onPrimary,
                large: true,
                onTap: () {
                  state.like(top);
                  setState(() => _dragDx = 0);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
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
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: fg, size: large ? 30 : 26),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
