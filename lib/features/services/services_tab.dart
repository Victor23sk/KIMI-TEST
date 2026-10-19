import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  static const _services = [
    (S.svcMortgageCalc, Icons.calculate_outlined, 'mortgage'),
    (S.svcCompare, Icons.compare_arrows_outlined, 'compare'),
    (S.svcUploadDocs, Icons.upload_file_outlined, 'docs'),
    (S.svcOnlineMortgage, Icons.account_balance_outlined, 'online-mortgage'),
    (S.svcEdeal, Icons.draw_outlined, 'edeal'),
    (S.svcFavorites, Icons.favorite_outline, 'favorites'),
    (S.svcDocCheck, Icons.fact_check_outlined, 'doc-check'),
    (S.svcTrading, Icons.swap_horiz_outlined, 'trading'),
    (S.svcProfile, Icons.person_outline, 'profile'),
    (S.svcSupport, Icons.support_agent_outlined, 'support'),
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
            child: Text(
              'Откройте сервис — рабочие экраны с демо-логикой',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
          sliver: SliverGrid(
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
                  onTap: () => context.push('/app/services/${s.$3}'),
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
                      Text(s.$1, style: Theme.of(context).textTheme.titleSmall, maxLines: 2),
                      const SizedBox(height: 4),
                      Text(
                        'Открыть',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.primary),
                      ),
                    ],
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
