import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import 'widgets/filter_widgets.dart';
import 'widgets/score_ball.dart';

class AgentTab extends StatefulWidget {
  const AgentTab({super.key});

  @override
  State<AgentTab> createState() => _AgentTabState();
}

class _AgentTabState extends State<AgentTab> {
  String? _goal; // living | investor
  RangeValues _budget = const RangeValues(12, 30);
  RangeValues _area = const RangeValues(35, 70);
  final Set<int> _rooms = {1, 2};
  double _metroMin = 15;
  final Set<String> _districts = {'САО'};
  String _finishing = 'whitebox';

  final _timeline = <_TimelineItem>[
    _TimelineItem('Система', 'Сессия поиска создана', Icons.play_arrow_outlined),
  ];

  void _setGoal(String goal) {
    setState(() {
      _goal = goal;
      _timeline.add(
        _TimelineItem(
          'Вы',
          goal == 'living' ? 'Цель: жить' : 'Цель: инвестировать',
          Icons.flag_outlined,
        ),
      );
      _timeline.add(
        _TimelineItem(
          'Агент',
          goal == 'living'
              ? 'Спрошу про семью, маршрут до работы и школы рядом.'
              : 'Спрошу про горизонт, доходность и ликвидность района.',
          Icons.smart_toy_outlined,
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

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text(S.tabAgent),
          actions: [
            IconButton(
              tooltip: S.clearHistory,
              onPressed: () => _toast('${S.clearHistory} (заглушка)'),
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: S.newSearch,
              onPressed: () => _toast('${S.newSearch} (заглушка)'),
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              tooltip: S.parallelSearch,
              onPressed: () => _toast('${S.parallelSearch} (заглушка)'),
              icon: const Icon(Icons.call_split_outlined),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScoreBall(score: null), // TBD formula
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.scoreBall,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.scoreTbd,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.raiseScore,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: cs.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Заполните цель и фильтры\n'
                            '• Оценивайте квартиры с причиной\n'
                            '• Веса событий — после файла скоринга',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ProbabilityDashboard(cs: cs),
                const SizedBox(height: 20),
                Text(S.timeline, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ..._timeline.map((e) => _TimelineTile(item: e)),
                if (_goal == null) ...[
                  const SizedBox(height: 12),
                  _AgentBubble(text: S.agentWelcome),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => _setGoal('living'),
                          child: const Text(S.goalLiving),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => _setGoal('investor'),
                          child: const Text(S.goalInvestor),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  _AgentBubble(
                    text: _goal == 'living'
                        ? 'Отлично. Настроим фильтры под жизнь в городе.'
                        : 'Отлично. Настроим фильтры под инвестиционный сценарий.',
                  ),
                ],
                const SizedBox(height: 24),
                Text(S.filters, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                FilterSectionCard(
                  title: S.budget,
                  child: BudgetRangeFilter(
                    values: _budget,
                    onChanged: (v) => setState(() => _budget = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.area,
                  child: AreaRangeFilter(
                    values: _area,
                    onChanged: (v) => setState(() => _area = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.rooms,
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
                  child: MetroSliderFilter(
                    minutes: _metroMin,
                    onChanged: (v) => setState(() => _metroMin = v),
                  ),
                ),
                FilterSectionCard(
                  title: S.districts,
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
                  child: FinishingSegmentFilter(
                    value: _finishing,
                    onChanged: (v) => setState(() => _finishing = v),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => _toast('${S.proposePrice} (заглушка)'),
                  icon: const Icon(Icons.sell_outlined),
                  label: const Text(S.proposePrice),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _toast('${S.massOutreach} (заглушка)'),
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text(S.massOutreach),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProbabilityDashboard extends StatelessWidget {
  const _ProbabilityDashboard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.probability, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const _ProbRow(label: S.inventoryFit, value: 0.62),
            const _ProbRow(label: S.competition, value: 0.41),
            const _ProbRow(label: S.budgetRealism, value: 0.78),
            const SizedBox(height: 4),
            Text(
              'Модели вероятностей — TBD',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
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
          LinearProgressIndicator(
            value: value,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
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
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.88),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSecondaryContainer,
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        child: Icon(item.icon, size: 20, color: cs.onPrimaryContainer),
      ),
      title: Text(item.actor, style: Theme.of(context).textTheme.labelLarge),
      subtitle: Text(item.text),
      dense: true,
    );
  }
}
