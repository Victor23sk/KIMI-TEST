import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';

class FilterSectionCard extends StatelessWidget {
  const FilterSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SurfaceCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        color: cs.surfaceContainerLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                ],
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class BudgetRangeFilter extends StatelessWidget {
  const BudgetRangeFilter({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeEnd,
  });

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${values.start.round()}–${values.end.round()} млн ₽',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        RangeSlider(
          values: values,
          min: 5,
          max: 80,
          divisions: 75,
          labels: RangeLabels('${values.start.round()}', '${values.end.round()}'),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}

class AreaRangeFilter extends StatelessWidget {
  const AreaRangeFilter({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeEnd,
  });

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${values.start.round()}–${values.end.round()} м²',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        RangeSlider(
          values: values,
          min: 20,
          max: 150,
          divisions: 130,
          labels: RangeLabels('${values.start.round()}', '${values.end.round()}'),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}

class RoomsChipFilter extends StatelessWidget {
  const RoomsChipFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [0, 1, 2, 3, 4];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((r) {
        final label = r == 0 ? 'Студия' : '$r-комн.';
        return FilterChip(
          label: Text(label),
          selected: selected.contains(r),
          showCheckmark: false,
          onSelected: (v) {
            final next = Set<int>.from(selected);
            if (v) {
              next.add(r);
            } else {
              next.remove(r);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

class MetroSliderFilter extends StatelessWidget {
  const MetroSliderFilter({
    super.key,
    required this.minutes,
    required this.onChanged,
    this.onChangeEnd,
  });

  final double minutes;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'до ${minutes.round()} мин пешком',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Slider(
          value: minutes,
          min: 5,
          max: 40,
          divisions: 7,
          label: '${minutes.round()} мин',
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}

class DistrictChipFilter extends StatelessWidget {
  const DistrictChipFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  static const options = ['ЦАО', 'САО', 'СВАО', 'ВАО', 'ЮВАО', 'ЮАО', 'ЮЗАО', 'ЗАО', 'СЗАО'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((d) {
        return FilterChip(
          label: Text(d),
          selected: selected.contains(d),
          showCheckmark: false,
          onSelected: (v) {
            final next = Set<String>.from(selected);
            if (v) {
              next.add(d);
            } else {
              next.remove(d);
            }
            onChanged(next);
          },
        );
      }).toList(),
    );
  }
}

class FinishingSegmentFilter extends StatelessWidget {
  const FinishingSegmentFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'none', label: Text('Без')),
        ButtonSegment(value: 'whitebox', label: Text('White box')),
        ButtonSegment(value: 'turnkey', label: Text('Под ключ')),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
