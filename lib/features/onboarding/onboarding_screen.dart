import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/routing/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  static const _pages = [
    (S.introTitle1, S.introBody1, Icons.smart_toy_outlined),
    (S.introTitle2, S.introBody2, Icons.swipe_outlined),
    (S.introTitle3, S.introBody3, Icons.sports_baseball_outlined),
    (S.introTitle4, S.introBody4, Icons.handshake_outlined),
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
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final last = _index == _pages.length - 1;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.surface, cs.surfaceContainerLow],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      S.appName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: cs.primary,
                          ),
                    ),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(page.$3, size: 72, color: cs.primary),
                          const SizedBox(height: 32),
                          Text(
                            page.$1,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.$2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  height: 1.45,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        final active = i == _index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: active ? 24 : 8,
                          decoration: BoxDecoration(
                            color: active ? cs.primary : cs.outlineVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
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
    );
  }
}
