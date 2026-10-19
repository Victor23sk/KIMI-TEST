import 'package:flutter/material.dart';

import '../../../core/widgets/brand_mark.dart';

class StubServiceScreen extends StatelessWidget {
  const StubServiceScreen({super.key, required this.slug});

  final String slug;

  static const _titles = {
    'online-mortgage': 'Онлайн-ипотека',
    'edeal': 'Электронная сделка',
    'doc-check': 'Проверка документов',
    'trading': 'Трейд-ин',
    'support': 'Поддержка',
  };

  @override
  Widget build(BuildContext context) {
    final title = _titles[slug] ?? slug;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ContentWidth(
        child: SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(
                'Экран сервиса открыт. Интеграция с партнёрами — после прототипа. '
                'UI и навигация уже в потоке TZ.',
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context),
                child: const Text('Назад к сервисам'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
