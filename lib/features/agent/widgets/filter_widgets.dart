import 'package:flutter/material.dart';

class FilterSectionCard extends StatelessWidget {
  const FilterSectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
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
  });

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${values.start.round()}–${values.end.round()} млн ₽',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        RangeSlider(
          values: values,
          min: 5,
          max: 80,
          divisions: 75,
          labels: RangeLabels(
            '${values.start.round()}',
            '${values.end.round()}',
          ),
          onChanged: onChanged,
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
  });

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${values.start.round()}–${values.end.round()} м²',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        RangeSlider(
          values: values,
          min: 20,
          max: 150,
          divisions: 130,
          labels: RangeLabels(
            '${values.start.round()}',
            '${values.end.round()}',
          ),
          onChanged: onChanged,
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
      children: options.map((r) {
        final label = r == 0 ? 'Студия' : '$r';
        final isOn = selected.contains(r);
        return FilterChip(
          label: Text(label),
          selected: isOn,
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
  });

  final double minutes;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'до ${minutes.round()} мин',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Slider(
          value: minutes,
          min: 5,
          max: 40,
          divisions: 7,
          label: '${minutes.round()} мин',
          onChanged: onChanged,
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
        final isOn = selected.contains(d);
        return FilterChip(
          label: Text(d),
          selected: isOn,
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
