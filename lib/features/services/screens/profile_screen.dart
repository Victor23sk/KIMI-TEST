import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ContentWidth(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            CircleAvatar(
              radius: 40,
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.person, size: 40, color: cs.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Пользователь Telegram', style: Theme.of(context).textTheme.titleLarge),
            Text('Демо-аккаунт · Max/TG stub', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            SurfaceCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('TQS'),
                    trailing: Text('${state.tqs.round()} · ${state.tqsBand}'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Избранное'),
                    trailing: Text('${state.favoriteIds.length}'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Активный поиск'),
                    trailing: Text(state.active.title),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Цель'),
                    trailing: Text(state.active.goal == 'investor'
                        ? 'Инвестировать'
                        : state.active.goal == 'living'
                            ? 'Жить'
                            : '—'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
