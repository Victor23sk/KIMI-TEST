import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  static const _services = [
    (S.svcMortgageCalc, Icons.calculate_outlined, true),
    (S.svcCompare, Icons.compare_arrows_outlined, true),
    (S.svcUploadDocs, Icons.upload_file_outlined, false),
    (S.svcOnlineMortgage, Icons.account_balance_outlined, false),
    (S.svcEdeal, Icons.draw_outlined, false),
    (S.svcFavorites, Icons.favorite_outline, true),
    (S.svcDocCheck, Icons.fact_check_outlined, false),
    (S.svcTrading, Icons.swap_horiz_outlined, false),
    (S.svcProfile, Icons.person_outline, true),
    (S.svcSupport, Icons.support_agent_outlined, true),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final cross = width >= 900 ? 4 : width >= 600 ? 3 : 2;

    return CustomScrollView(
      slivers: [
        const SliverAppBar.medium(title: Text(S.servicesTitle)),
        SliverToBoxAdapter(
          child: ContentWidth(
            maxWidth: AppSpacing.maxWideWidth,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'Инструменты до сделки — ипотека, документы, сравнение',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final s = _services[i];
                    return SurfaceCard(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${s.$1} — ${S.comingSoon}')),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(AppRadii.md),
                            ),
                            child: Icon(s.$2, color: cs.onPrimaryContainer),
                          ),
                          const Spacer(),
                          Text(
                            s.$1,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.$3 ? 'Скоро · MVP' : S.comingSoon,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: _services.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
