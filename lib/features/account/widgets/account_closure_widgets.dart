import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../home/widgets/kit/kit.dart';

/// Proyecto en cierre: foto de 78×88, título con estado y chevron.
class AccountClosureProject extends StatelessWidget {
  const AccountClosureProject({super.key});

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 102,
      radius: ProRadii.card,
      borderWidth: ProStroke.hairline,
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          const ProImage(ProAssets.greenLivingRoom, width: 78, height: 88, radius: 10),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Expanded(child: Text('Pintar sala y comedor', style: ProText.labelStrong)),
                    ProChip(
                      'Listo para cerrar',
                      background: ProColors.successLight,
                      foreground: ProColors.brand700,
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      textStyle: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                    ),
                  ],
                ),
                Text(
                  'Pintura y estuco\n♧ Bogotá D.C.',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 12.65),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

/// Tarjeta con quien confirma el trabajo: cliente y contratista.
class AccountClosureConfirmations extends StatelessWidget {
  const AccountClosureConfirmations({super.key});

  static const _rows = [
    'Cliente · Juan Pérez',
    'Contratista · Carlos Ramírez',
  ];

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 88,
      radius: ProRadii.lg,
      borderWidth: 0.6,
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          for (final row in _rows)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
              ),
              child: Row(
                children: [
                  const ProIcon(LucideIcon.user, size: 23),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: row, style: ProText.r(12, lineHeight: 15.6)),
                        TextSpan(
                          text: '\n✓ Trabajo confirmado',
                          style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const ProIcon(LucideIcon.chevronRight, size: 15),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Cinco estrellas tocables: las primeras [value] se pintan rellenas.
class AccountStarRating extends StatelessWidget {
  const AccountStarRating({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const Color _color = Color(0xFFE3A02A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Text(
                i <= value ? '★' : '☆',
                style: ProText.r(29, color: _color, lineHeight: 34.8),
              ),
            ),
          ),
      ],
    );
  }
}

/// Campo de reseña sin borde: el placeholder de Figma y el contador "n/500".
class AccountReviewField extends StatelessWidget {
  const AccountReviewField({super.key, required this.controller, required this.maxLength});

  final TextEditingController controller;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 9,
      children: [
        SizedBox(
          height: 28,
          child: TextField(
            controller: controller,
            maxLines: 2,
            inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
            style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
            decoration: InputDecoration.collapsed(
              hintText: 'Cuéntanos cómo fue tu experiencia...\n(Ej. calidad del trabajo, cumplimiento, comunicación)',
              hintStyle: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
            ),
          ),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Text(
            '${controller.text.length}/$maxLength',
            textAlign: TextAlign.center,
            style: ProText.r(11, color: ProColors.ink700, lineHeight: 13.2),
          ),
        ),
      ],
    );
  }
}

/// Aviso de problemas en fondo ámbar suave.
class AccountClosureNotice extends StatelessWidget {
  const AccountClosureNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ProColors.warningLight, borderRadius: BorderRadius.circular(ProRadii.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProIcon(LucideIcon.circleAlert, size: 23, color: ProColors.sun300),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '¿Tuviste algún problema? Si algo no salió como esperabas, puedes reportarlo para que lo revisemos.',
              style: ProText.r(12, color: ProColors.ink500, lineHeight: 14.4),
            ),
          ),
        ],
      ),
    );
  }
}
