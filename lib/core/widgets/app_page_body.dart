import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_card.dart';

/// Cuerpo desplazable de una pantalla con marco de tarjeta fijo.
///
/// - El marco blanco redondeado ([AppSpacing.roundedLg]) permanece fijo para
///   que al hacer scroll los bordes superiores e inferiores nunca se vuelvan
///   puntiagudos.
/// - Si se indica [fixedHeader] (por ejemplo buscador y botón de filtros),
///   este permanece fijo en la parte superior de la tarjeta y el scroll solo
///   desplaza la lista inferior, que desaparece justo antes de tocar el
///   buscador o los filtros.
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    super.key,
    required this.children,
    this.fixedHeader,
    this.footer,
    this.controller,
    this.onRefresh,
  });

  final List<Widget> children;
  final Widget? fixedHeader;
  final Widget? footer;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;

  List<Widget> _unwrapSingleCard(List<Widget> items) {
    if (items.length == 1 && items.first is AppCard) {
      final card = items.first as AppCard;
      if (card.onTap == null && card.backgroundColor == AppColors.surface0) {
        return [card.child];
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveChildren = _unwrapSingleCard(children);

    Widget scrollView = CustomScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _KeepAliveChild(
              child: effectiveChildren[index],
            ),
            childCount: effectiveChildren.length,
            addRepaintBoundaries: true,
            addAutomaticKeepAlives: true,
          ),
        ),
      ],
    );

    final refresh = onRefresh;
    if (refresh != null) {
      scrollView = RefreshIndicator(
        color: AppColors.brand700,
        onRefresh: refresh,
        child: scrollView,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        31,
        AppSpacing.screenGutter,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface0,
                borderRadius: AppSpacing.roundedLg,
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: AppSpacing.roundedLg,
                border: Border.all(
                  color: AppColors.line300,
                  width: AppSpacing.strokeCard,
                ),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (fixedHeader != null) ...[
                    RepaintBoundary(child: fixedHeader!),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Expanded(
                    child: ClipRect(
                      child: RepaintBoundary(
                        child: scrollView,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            RepaintBoundary(child: footer!),
          ],
        ],
      ),
    );
  }
}

class _KeepAliveChild extends StatefulWidget {
  const _KeepAliveChild({required this.child});

  final Widget child;

  @override
  State<_KeepAliveChild> createState() => _KeepAliveChildState();
}

class _KeepAliveChildState extends State<_KeepAliveChild>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
