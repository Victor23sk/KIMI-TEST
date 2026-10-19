import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';

Future<String?> showRejectReasonSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _RejectReasonSheet(),
  );
}

class _RejectReasonSheet extends StatelessWidget {
  const _RejectReasonSheet();

  static const _reasons = [
    (S.reasonPrice, 'price'),
    (S.reasonPlan, 'plan'),
    (S.reasonDistrict, 'district'),
    (S.reasonZhk, 'zhk'),
    (S.reasonFloor, 'floor'),
    (S.reasonOther, 'other'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.rejectReasonTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Можно пропустить — трение минимальное',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons
                  .map(
                    (r) => ActionChip(
                      label: Text(r.$1),
                      onPressed: () => Navigator.pop(context, r.$1),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
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
