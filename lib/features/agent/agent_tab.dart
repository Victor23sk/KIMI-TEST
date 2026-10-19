import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';
import '../../state/app_state.dart';
import 'sheets/outreach_sheets.dart';
import 'widgets/filter_widgets.dart';
import 'widgets/score_ball.dart';

class AgentTab extends StatelessWidget {
  const AgentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final s = state.active;
    final cs = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final filters = s.filters;
    final prob = s.probability();

    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          title: const Text(S.tabAgent),
          actions: [
            IconButton(
              tooltip: S.clearHistory,
              onPressed: state.clearHistory,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
            IconButton(
              tooltip: S.newSearch,
              onPressed: state.newSearch,
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
            IconButton(
              tooltip: S.parallelSearch,
              onPressed: () => state.selectSearch(state.activeIndex == 0 ? 1 : 0),
              icon: const Icon(Icons.call_split_rounded),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: ContentWidth(
            maxWidth: wide ? AppSpacing.maxWideWidth : AppSpacing.maxContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: Text(state.sessions[0].title),
                      icon: const Icon(Icons.search_rounded, size: 18),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text(state.sessions[1].title),
                      icon: const Icon(Icons.layers_outlined, size: 18),
                    ),
                  ],
                  selected: {state.activeIndex},
                  onSelectionChanged: (v) => state.selectSearch(v.first),
                ),
                const SizedBox(height: AppSpacing.md),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _ScoreBlock(state: state, prob: prob)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 6, child: _ChatBlock(state: state)),
                    ],
                  )
                else ...[
                  _ScoreBlock(state: state, prob: prob),
                  const SizedBox(height: AppSpacing.md),
                  _ChatBlock(state: state),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(S.filters, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Изменения сразу влияют на колоду в «Поиске» и вероятности',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilterSectionCard(
                  title: S.budget,
                  icon: Icons.payments_outlined,
                  child: BudgetRangeFilter(
                    values: RangeValues(filters.budget.start, filters.budget.end),
                    onChanged: (v) => state.updateBudget(v.start, v.end, commit: false),
                    onChangeEnd: (v) => state.updateBudget(v.start, v.end),
                  ),
                ),
                FilterSectionCard(
                  title: S.area,
                  icon: Icons.square_foot_outlined,
                  child: AreaRangeFilter(
                    values: RangeValues(filters.area.start, filters.area.end),
                    onChanged: (v) => state.updateArea(v.start, v.end, commit: false),
                    onChangeEnd: (v) => state.updateArea(v.start, v.end),
                  ),
                ),
                FilterSectionCard(
                  title: S.rooms,
                  icon: Icons.meeting_room_outlined,
                  child: RoomsChipFilter(
                    selected: filters.rooms,
                    onChanged: state.updateRooms,
                  ),
                ),
                FilterSectionCard(
                  title: S.metro,
                  icon: Icons.directions_subway_outlined,
                  child: MetroSliderFilter(
                    minutes: filters.metroMin,
                    onChanged: (v) => state.updateMetro(v, commit: false),
                    onChangeEnd: state.updateMetro,
                  ),
                ),
                FilterSectionCard(
                  title: S.districts,
                  icon: Icons.map_outlined,
                  child: DistrictChipFilter(
                    selected: filters.districts,
                    onChanged: state.updateDistricts,
                  ),
                ),
                FilterSectionCard(
                  title: S.finishing,
                  icon: Icons.home_repair_service_outlined,
                  child: FinishingSegmentFilter(
                    value: filters.finishing,
                    onChanged: state.updateFinishing,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => showPriceOfferSheet(context),
                  icon: const Icon(Icons.sell_outlined),
                  label: const Text(S.proposePrice),
                ),
                const SizedBox(height: AppSpacing.xs),
                OutlinedButton.icon(
                  onPressed: () => showMassOutreachSheet(context),
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
}

class _ScoreBlock extends StatelessWidget {
  const _ScoreBlock({required this.state, required this.prob});

  final AppState state;
  final Map<String, double> prob;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScoreBall(score: state.tqs, bandLabel: state.tqsBand),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.scoreBall, style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          S.scoreTqsHint,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          S.raiseScore,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.primary),
                        ),
                        const SizedBox(height: 6),
                        RaiseScoreActions(actions: state.raiseActions),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _Meter(S.scoreComponentPcqs, state.pcqs, 0.25),
              _Meter(S.scoreComponentBps, state.bpsQuality, 0.20),
              _Meter(S.scoreComponentOsas, (state.osas + 18).clamp(0, 100), 0.35),
              _Meter(S.scoreComponentLqs, state.lqs, 0.20),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.probability, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _Prob(S.inventoryFit, prob['inventoryFit']!),
              _Prob(S.competition, prob['competition']!),
              _Prob(S.budgetRealism, prob['budgetRealism']!),
              Text(
                'По текущим фильтрам: ${state.active.filteredCatalog().length} лотов в колоде',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatBlock extends StatelessWidget {
  const _ChatBlock({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final s = state.active;
    final cs = Theme.of(context).colorScheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.timeline, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          ...s.timeline.reversed.take(12).map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.circle, size: 8, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.actor, style: Theme.of(context).textTheme.labelLarge),
                        Text(
                          e.text,
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
          }),
          if (s.goal == null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Text(
                S.agentWelcome,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSecondaryContainer,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => state.setGoal('living'),
                    icon: const Icon(Icons.home_outlined),
                    label: const Text(S.goalLiving),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => state.setGoal('investor'),
                    icon: const Icon(Icons.trending_up_rounded),
                    label: const Text(S.goalInvestor),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Meter extends StatelessWidget {
  const _Meter(this.label, this.value, this.weight);
  final String label;
  final double value;
  final double weight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
              Text('${value.round()} · ${(weight * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: (value / 100).clamp(0, 1), minHeight: 6),
          ),
        ],
      ),
    );
  }
}

class _Prob extends StatelessWidget {
  const _Prob(this.label, this.value);
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
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
