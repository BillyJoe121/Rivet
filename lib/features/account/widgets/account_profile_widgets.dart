import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Resumen de la persona: nombre en Lora y tres líneas de datos de Figma.
class ProfileSummaryText extends StatelessWidget {
  const ProfileSummaryText({
    super.key,
    required this.name,
    required this.trade,
    required this.zone,
    required this.rating,
  });

  final String name;
  final String trade;
  final String zone;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final small = ProText.r(11, color: ProColors.ink500, lineHeight: 14.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: ProText.serif(16, color: ProColors.ink900, lineHeight: 19.2)),
        Text(trade, style: ProText.r(12, color: ProColors.ink500, lineHeight: 15.6)),
        Text(zone, style: small),
        Text(rating, style: small),
      ],
    );
  }
}

/// Servicio con ícono de trazo, título y alcance centrados.
class ProfileServiceTile extends StatelessWidget {
  const ProfileServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.scope,
    this.height = 76,
    this.iconSize = 28,
    this.gap = 5,
    this.padding = const EdgeInsets.all(8),
    this.titleSize = 12,
    this.scopeSize = 11,
  });

  final LucideIcon icon;
  final String title;
  final String scope;
  final double height;
  final double iconSize;
  final double gap;
  final EdgeInsetsGeometry padding;
  final double titleSize;
  final double scopeSize;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: height,
      radius: ProRadii.card,
      borderWidth: ProStroke.card,
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProIcon(icon, size: iconSize),
          SizedBox(height: gap),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: title, style: ProText.r(titleSize, weight: FontWeight.w600, lineHeight: titleSize * 1.2)),
              TextSpan(text: '\n$scope', style: ProText.r(scopeSize, color: ProColors.ink500, lineHeight: scopeSize * 1.2)),
            ]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Foto de portafolio con su descripción debajo.
class ProfileGalleryTile extends StatelessWidget {
  const ProfileGalleryTile({super.key, required this.image, required this.caption, this.imageHeight = 118});

  final String image;
  final String caption;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProImage(image, width: double.infinity, height: imageHeight, radius: ProRadii.sm),
        const SizedBox(height: 5),
        Text(caption, style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2)),
      ],
    );
  }
}

/// Cabecera modular del perfil con avatar interactivo y badge de estado Supabase.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.initials,
    required this.displayName,
    required this.roleTitle,
    required this.onTapAvatar,
  });

  final String initials;
  final String displayName;
  final String roleTitle;
  final VoidCallback onTapAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Semantics(
              button: true,
              label: 'Cambiar rol activo',
              child: GestureDetector(
                onTap: onTapAvatar,
                child: ProInitialsAvatar(
                  initials.isNotEmpty ? initials : 'RV',
                  size: 88,
                  textStyle: ProText.serif(29, weight: FontWeight.w400, color: ProColors.surface0, lineHeight: 34.8),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: ProText.serif(22, color: ProColors.ink700, lineHeight: 26.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    roleTitle,
                    style: ProText.r(13, color: ProColors.ink500),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ProChip(
          '✓ Perfil activo en Supabase',
          background: ProColors.successLight,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          textStyle: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
        ),
      ],
    );
  }
}

/// Diálogo de confirmación para cerrar sesión con identidad visual Rivet.
class ConfirmSignOutDialog extends StatelessWidget {
  const ConfirmSignOutDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmSignOutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('¿Cerrar sesión?'),
      content: const Text('¿Estás seguro de que deseas salir de tu cuenta en Rivet?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ProColors.brand700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
