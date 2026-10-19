import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';
import 'widgets/filter_widgets.dart';
import 'widgets/score_ball.dart';

class AgentTab extends StatefulWidget {
  const AgentTab({super.key});

  @override
  State<AgentTab> createState() => _AgentTabState();
}

class _AgentTabState extends State<AgentTab> {
  String? _goal;
  int _activeSearch = 0; // dual search index
  RangeValues _budget = const RangeValues(12, 30);
  RangeValues _area = const RangeValues(35, 70);
  final Set<int> _rooms = {1, 2};
  double _metroMin = 15;
  final Set<String> _districts = {'САО'};
  String _finishing = 'whitebox';

  final _timeline = <_TimelineItem>[
    _TimelineItem('Система', 'Сессия поиска A создана', Icons.play_arrow_rounded),
  ];

  void _setGoal(String goal) {
    setState(() {
      _goal = goal;
      _timeline.add(
        _TimelineItem(
          'Вы',
          goal == 'living' ? 'Цель: жить' : 'Цель: инвестировать',
          Icons.flag_rounded,
        ),
      );
      _timeline.add(
        _TimelineItem(
          'Агент',
          goal == 'living'
              ? 'Спрошу про семью, маршрут до работы и школы рядом.'
              : 'Спрошу про горизонт, доходность и ликвидность района.',
          Icons.auto_awesome_rounded,
        ),
      );
    });
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          title: const Text(S.tabAgent),
          actions: [
            IconButton(
              tooltip: S.clearHistory,
              onPressed: () => _toast('${S.clearHistory} (заглушка)'),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
            IconButton(
              tooltip: S.newSearch,
              onPressed: () => _toast('${S.newSearch} (заглушка)'),
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
            IconButton(
              tooltip: S.parallelSearch,
              onPressed: () {
                setState(() => _activeSearch = _activeSearch == 0 ? 1 : 0);
                _toast('${S.parallelSearch}: ${_activeSearch == 0 ? 'A' : 'B'}');
              },
              icon: const Icon(Icons.call_split_rounded),
            ),
            const SizedBox(width: 4),
          ],
        ),
        SliverToBoxAdapter(
          child: ContentWidth(
            maxWidth: wide ? AppSpacing.maxWideWidth : AppSpacing.maxContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SearchSwitcher(
                  active: _activeSearch,
                  onChanged: (i) => setState(() => _activeSearch = i),
                ),
                const SizedBox(height: AppSpacing.md),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildScoreAndProb(cs)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 6, child: _buildChat(cs)),
                    ],
                  )
                else ...[
                  _buildScoreAndProb(cs),
                  const SizedBox(height: AppSpacing.md),
                  _buildChat(cs),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(S.filters, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Каждый фильтр — отдельный виджет, изменения попадают в историю',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilterSectionCard(
                  title: S.budget,
                  icon: Icons.payments_outlined,
                  child: BudgetRangeFilter(
                    values: _budget,
                    onChanged: (v) => setState(() => _budget = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.area,
                  icon: Icons.square_foot_outlined,
                  child: AreaRangeFilter(
                    values: _area,
                    onChanged: (v) => setState(() => _area = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.rooms,
                  icon: Icons.meeting_room_outlined,
                  child: RoomsChipFilter(
                    selected: _rooms,
                    onChanged: (v) => setState(() {
                      _rooms
                        ..clear()
                        ..addAll(v);
                    }),
                  ),
                ),
                FilterSectionCard(
                  title: S.metro,
                  icon: Icons.directions_subway_outlined,
                  child: MetroSliderFilter(
                    minutes: _metroMin,
                    onChanged: (v) => setState(() => _metroMin = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.districts,
                  icon: Icons.map_outlined,
                  child: DistrictChipFilter(
                    selected: _districts,
                    onChanged: (v) => setState(() {
                      _districts
                        ..clear()
                        ..addAll(v);
                    }),
                  ),
                ),
                FilterSectionCard(
                  title: S.finishing,
                  icon: Icons.home_repair_service_outlined,
                  child: FinishingSegmentFilter(
                    value: _finishing,
                    onChanged: (v) => setState(() => _finishing = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => _toast('${S.proposePrice} (заглушка)'),
                  icon: const Icon(Icons.sell_outlined),
                  label: const Text(S.proposePrice),
                ),
                const SizedBox(height: AppSpacing.xs),
                OutlinedButton.icon(
                  onPressed: () => _toast('${S.massOutreach} (заглушка)'),
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text(S.massOutreach),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreAndProb(ColorScheme cs) {
    return Column(
      children: [
        SurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScoreBall(score: 62),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.scoreBall, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          S.scoreTqsHint,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          S.raiseScore,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: cs.primary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const RaiseScoreActions(
                          actions: [
                            'Откройте 2–3 планировки (+15 OSAS каждая)',
                            'Добавьте в избранное (+20)',
                            'Укажите конкретный ЖК в заявке (LQS до +30)',
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _TqsMeters(pcqs: 70, bpsQuality: 96, osas: 48, lqs: 40),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.probability, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _ProbRow(label: S.inventoryFit, value: 0.62),
              const _ProbRow(label: S.competition, value: 0.41),
              const _ProbRow(label: S.budgetRealism, value: 0.78),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChat(ColorScheme cs) {
    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.timeline, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          ..._timeline.map((e) => _TimelineTile(item: e)),
          if (_goal == null) ...[
            const SizedBox(height: AppSpacing.sm),
            _AgentBubble(text: S.agentWelcome),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _setGoal('living'),
                    icon: const Icon(Icons.home_outlined),
                    label: const Text(S.goalLiving),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _setGoal('investor'),
                    icon: const Icon(Icons.trending_up_rounded),
                    label: const Text(S.goalInvestor),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.sm),
            _AgentBubble(
              text: _goal == 'living'
                  ? 'Отлично. Настроим фильтры под жизнь в городе.'
                  : 'Отлично. Настроим фильтры под инвестиционный сценарий.',
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchSwitcher extends StatelessWidget {
  const _SearchSwitcher({required this.active, required this.onChanged});

  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 0, label: Text('Поиск A'), icon: Icon(Icons.search_rounded, size: 18)),
        ButtonSegment(value: 1, label: Text('Поиск B'), icon: Icon(Icons.layers_outlined, size: 18)),
      ],
      selected: {active},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _TqsMeters extends StatelessWidget {
  const _TqsMeters({
    required this.pcqs,
    required this.bpsQuality,
    required this.osas,
    required this.lqs,
  });

  final double pcqs;
  final double bpsQuality;
  final double osas;
  final double lqs;

  @override
  Widget build(BuildContext context) {
    final items = [
      (S.scoreComponentPcqs, pcqs, 0.25),
      (S.scoreComponentBps, bpsQuality, 0.20),
      (S.scoreComponentOsas, osas, 0.35),
      (S.scoreComponentLqs, lqs, 0.20),
    ];
    return Column(
      children: items.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(e.$1, style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Text(
                    '${e.$2.round()} · ${(e.$3 * 100).round()}%',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: e.$2 / 100,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProbRow extends StatelessWidget {
  const _ProbRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
              Text('${(value * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: value, minHeight: 6),
          ),
        ],
      ),
    );
  }
}

class _AgentBubble extends StatelessWidget {
  const _AgentBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSecondaryContainer,
                    height: 1.4,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineItem {
  _TimelineItem(this.actor, this.text, this.icon);

  final String actor;
  final String text;
  final IconData icon;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item});

  final _TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: cs.primaryContainer,
            child: Icon(item.icon, size: 16, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.actor, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  item.text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
