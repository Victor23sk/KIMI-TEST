import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

/// Palazzo wordmark — hero-level brand signal.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = BrandMarkSize.hero,
    this.color,
    this.showAi = true,
  });

  final BrandMarkSize size;
  final Color? color;
  final bool showAi;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    final style = switch (size) {
      BrandMarkSize.hero => Theme.of(context).textTheme.displayMedium,
      BrandMarkSize.large => Theme.of(context).textTheme.headlineMedium,
      BrandMarkSize.nav => Theme.of(context).textTheme.titleLarge,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          S.appName,
          style: style?.copyWith(color: c, letterSpacing: -1.1),
        ),
        if (showAi) ...[
          const SizedBox(width: 6),
          Text(
            'AI',
            style: (size == BrandMarkSize.hero
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context).textTheme.titleMedium)
                ?.copyWith(
              color: cs.tertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

enum BrandMarkSize { hero, large, nav }

/// Soft architectural mesh gradient for pre-auth surfaces.
class AtmosphereBackground extends StatelessWidget {
  const AtmosphereBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer.withValues(alpha: 0.55),
            cs.surface,
            cs.tertiaryContainer.withValues(alpha: 0.4),
            cs.surfaceContainerLow,
          ],
          stops: const [0, 0.35, 0.75, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _Blob(
              size: 260,
              color: cs.primary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -50,
            child: _Blob(
              size: 220,
              color: cs.tertiary.withValues(alpha: 0.1),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

/// Constrains content for desktop while staying edge-to-edge on phones.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadii.lg);
    final material = Material(
      color: color ?? cs.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
    return material;
  }
}
