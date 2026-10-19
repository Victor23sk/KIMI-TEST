import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';

Future<String?> showRejectReasonSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _RejectReasonSheet(),
  );
}

class _RejectReasonSheet extends StatelessWidget {
  const _RejectReasonSheet();

  static const _reasons = [
    (S.reasonPrice, Icons.payments_outlined),
    (S.reasonPlan, Icons.grid_on_outlined),
    (S.reasonDistrict, Icons.map_outlined),
    (S.reasonZhk, Icons.apartment_outlined),
    (S.reasonFloor, Icons.stairs_outlined),
    (S.reasonOther, Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(S.rejectReasonTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Один тап — без трения. Можно пропустить.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons
                  .map(
                    (r) => ActionChip(
                      avatar: Icon(r.$2, size: 18),
                      label: Text(r.$1),
                      onPressed: () => Navigator.pop(context, r.$1),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Пропустить'),
            ),
          ],
        ),
      ),
    );
  }
}
