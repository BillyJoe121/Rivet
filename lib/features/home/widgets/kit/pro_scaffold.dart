import 'package:flutter/material.dart';

import 'pro_buttons.dart';
import 'pro_icon.dart';
import 'pro_surfaces.dart';
import 'pro_tokens.dart';

/// Contenedor de pantalla de Figma: lienzo marfil, ilustración de cabecera
/// de 412×232 detrás de la barra de estado, cuerpo desplazable y, si aplica,
/// pie fijo y navegación inferior.
class ProScreen extends StatelessWidget {
  const ProScreen({
    super.key,
    required this.body,
    this.backgroundAsset,
    this.footer,
    this.background = ProColors.paper100,
    this.scrollable = true,
    this.navWhenPushed,
  });

  final Widget body;
  final String? backgroundAsset;
  final Widget? footer;
  final Color background;
  final bool scrollable;

  /// Destino activo de la navegación inferior cuando la pantalla se abre con
  /// push; dentro del shell (ruta raíz) la navegación la pone el shell.
  final ProNavDestination? navWhenPushed;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final pushed = ModalRoute.of(context)?.canPop ?? false;
    final bottomNav = navWhenPushed != null && pushed ? ProBottomNav(active: navWhenPushed) : null;
    final content = Stack(
      children: [
        if (backgroundAsset != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: ProLayout.headerImageHeight,
            child: Image.asset(
              backgroundAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        Padding(padding: EdgeInsets.only(top: top), child: body),
      ],
    );
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: bottomNav != null || footer != null,
              child: scrollable ? SingleChildScrollView(child: content) : content,
            ),
          ),
          ?footer,
          ?bottomNav,
        ],
      ),
    );
  }
}

/// Cabecera de inicio: logotipo "Rivet", campana, avatar y saludo.
class ProBrandHeader extends StatelessWidget {
  const ProBrandHeader({
    super.key,
    required this.initials,
    required this.title,
    this.onBellTap,
    this.onAvatarTap,
  });

  final String initials;
  final String title;
  final VoidCallback? onBellTap;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(child: Text('Rivet', style: ProText.wordmark)),
                  GestureDetector(
                    onTap: onBellTap,
                    child: const ProIcon(LucideIcon.bell, size: 22),
                  ),
                  GestureDetector(onTap: onAvatarTap, child: ProInitialsAvatar(initials)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: ProText.pageTitle),
          ],
        ),
      ),
    );
  }
}

/// Destinos de la navegación principal de Figma.
enum ProNavDestination {
  home('Inicio', LucideIcon.house),
  projects('Proyectos', LucideIcon.files),
  proposals('Propuestas', LucideIcon.tag),
  messages('Mensajes', LucideIcon.messageSquare),
  more('Más', LucideIcon.ellipsis);

  const ProNavDestination(this.label, this.icon);
  final String label;
  final LucideIcon icon;
}

/// Navegación inferior de 80 px con borde superior de 1 px y zona de gestos
/// blanca. [centered] reproduce la variante con destinos centrados.
class ProBottomNav extends StatelessWidget {
  const ProBottomNav({
    super.key,
    required this.active,
    this.onSelect,
    this.centered = false,
  });

  final ProNavDestination? active;
  final ValueChanged<ProNavDestination>? onSelect;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: ProColors.surface0,
        border: Border(top: BorderSide(color: ProColors.line300, width: ProStroke.divider)),
      ),
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: ProLayout.navHeight - ProStroke.divider,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14 - ProStroke.divider, 12, 0),
          child: Row(
            crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              for (final d in ProNavDestination.values)
                Expanded(child: _NavItem(d, selected: d == active, onTap: () => _select(context, d))),
            ],
          ),
        ),
      ),
    );
  }

  void _select(BuildContext context, ProNavDestination d) {
    if (onSelect != null) {
      onSelect!(d);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.destination, {required this.selected, required this.onTap});

  final ProNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? ProColors.brand700 : ProColors.ink500;
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProIcon(destination.icon, size: 21, color: color),
            const SizedBox(height: 8),
            Text(destination.label, style: ProText.micro.copyWith(color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Título de página Lora 600 28.
class ProPageTitle extends StatelessWidget {
  const ProPageTitle(this.text, {super.key, this.maxWidth});

  final String text;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final title = Text(text, style: ProText.pageTitle);
    return maxWidth == null ? title : SizedBox(width: maxWidth, child: title);
  }
}

/// Cabecera de regreso. [inline] coloca el título a la derecha del botón
/// (x = 64); si no, el título va debajo. Los valores por defecto son los de
/// la cabecera de pantallas de detalle (padding 14/24/0/24 y gap 8).
class ProBackHeader extends StatelessWidget {
  const ProBackHeader({
    super.key,
    required this.title,
    this.inline = false,
    this.lucideChevron = false,
    this.padding = const EdgeInsets.fromLTRB(24, 14, 24, 0),
    this.gap = 8,
    this.height,
    this.titleWidth,
    this.onBack,
  });

  final String title;
  final bool inline;
  final bool lucideChevron;
  final EdgeInsets padding;
  final double gap;
  final double? height;
  final double? titleWidth;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final back = ProBackButton(lucide: lucideChevron, onTap: onBack);
    final child = inline
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              back,
              const SizedBox(width: 10),
              Expanded(child: ProPageTitle(title, maxWidth: titleWidth)),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [back, SizedBox(height: gap), ProPageTitle(title, maxWidth: titleWidth)],
          );
    return SizedBox(height: height, child: Padding(padding: padding, child: child));
  }
}
