import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  static const _services = [
    (S.svcMortgageCalc, Icons.calculate_outlined),
    (S.svcCompare, Icons.compare_arrows_outlined),
    (S.svcUploadDocs, Icons.upload_file_outlined),
    (S.svcOnlineMortgage, Icons.account_balance_outlined),
    (S.svcEdeal, Icons.draw_outlined),
    (S.svcFavorites, Icons.favorite_outline),
    (S.svcDocCheck, Icons.fact_check_outlined),
    (S.svcTrading, Icons.swap_horiz_outlined),
    (S.svcProfile, Icons.person_outline),
    (S.svcSupport, Icons.support_agent_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(title: Text(S.servicesTitle)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final s = _services[i];
                return Material(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${s.$1} — ${S.comingSoon}')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(s.$2, color: cs.primary, size: 28),
                          const Spacer(),
                          Text(
                            s.$1,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.comingSoon,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: _services.length,
            ),
          ),
        ),
      ],
    );
  }
}
