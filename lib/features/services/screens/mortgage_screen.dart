import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';

class MortgageScreen extends StatefulWidget {
  const MortgageScreen({super.key});

  @override
  State<MortgageScreen> createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  double price = 22; // млн
  double down = 20; // %
  double rate = 18; // %
  double years = 20;

  double get payment {
    final loan = price * 1e6 * (1 - down / 100);
    final r = rate / 100 / 12;
    final n = years * 12;
    if (r == 0) return loan / n;
    return loan * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ипотечный калькулятор')),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(payment / 1000).toStringAsFixed(1)} тыс ₽ / мес',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Платёж при ${rate.round()}% на ${years.round()} лет',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _slider('Стоимость, млн ₽', price, 8, 60, (v) => setState(() => price = v)),
            _slider('Первый взнос, %', down, 10, 50, (v) => setState(() => down = v)),
            _slider('Ставка, %', rate, 8, 28, (v) => setState(() => rate = v)),
            _slider('Срок, лет', years, 5, 30, (v) => setState(() => years = v)),
          ],
        ),
      ),
    );
  }

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label · ${value.round()}'),
          Slider(value: value, min: min, max: max, divisions: (max - min).round(), onChanged: onChanged),
        ],
      ),
    );
  }
}
