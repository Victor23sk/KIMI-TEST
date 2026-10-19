import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  static const _pages = [
    (
      S.introTitle1,
      S.introBody1,
      Icons.forum_rounded,
      'Агент ведёт диалог и собирает точные фильтры'
    ),
    (
      S.introTitle2,
      S.introBody2,
      Icons.swipe_rounded,
      'Планировка — главный кадр решения'
    ),
    (
      S.introTitle3,
      S.introBody3,
      Icons.sports_baseball_rounded,
      'TQS показывает готовность к сильной заявке'
    ),
    (
      S.introTitle4,
      S.introBody4,
      Icons.handshake_rounded,
      'От подбора до сделки в одном приложении'
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goAuth() => context.go(AppRoutes.auth);

  void _next() {
    if (_index >= _pages.length - 1) {
      _goAuth();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final last = _index == _pages.length - 1;
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return Scaffold(
      body: AtmosphereBackground(
        child: SafeArea(
          child: ContentWidth(
            maxWidth: wide ? AppSpacing.maxWideWidth : AppSpacing.maxContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Row(
                    children: [
                      const BrandMark(size: BrandMarkSize.nav),
                      const Spacer(),
                      TextButton(onPressed: _goAuth, child: const Text(S.skip)),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final page = _pages[i];
                      return _IntroPage(
                        title: page.$1,
                        body: page.$2,
                        icon: page.$3,
                        caption: page.$4,
                        active: i == _index,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (i) {
                          final active = i == _index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: active ? 28 : 8,
                            decoration: BoxDecoration(
                              color: active ? cs.primary : cs.outlineVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: _next,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            last ? S.start : S.next,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.title,
    required this.body,
    required this.icon,
    required this.caption,
    required this.active,
  });

  final String title;
  final String body;
  final IconData icon;
  final String caption;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 320),
      opacity: active ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
                ),
                borderRadius: BorderRadius.circular(AppRadii.xxl),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.22),
                    blurRadius: 32,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Icon(icon, size: 52, color: cs.onPrimary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: cs.tertiaryContainer.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Text(
                caption,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: cs.onTertiaryContainer,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
