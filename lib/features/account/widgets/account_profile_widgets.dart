import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../home/widgets/kit/kit.dart';

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
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTapAvatar();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ProInitialsAvatar(
                      initials.isNotEmpty ? initials : 'RV',
                      size: 88,
                      textStyle: ProText.serif(29, weight: FontWeight.w400, color: ProColors.surface0, lineHeight: 34.8),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: ProColors.surface0,
                          shape: BoxShape.circle,
                          border: Border.all(color: ProColors.brand700, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.swap_horiz_rounded,
                          size: 16,
                          color: ProColors.brand700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: ProColors.surface0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFDE8E8),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFF9B1C1C),
                size: 26,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¿Cerrar sesión?',
              style: ProText.serif(20, weight: FontWeight.w700, color: ProColors.ink900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '¿Estás seguro de que deseas salir de tu cuenta en Rivet? Tendrás que volver a autenticarte.',
              style: ProText.r(14, color: ProColors.ink500, lineHeight: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancelar',
                      style: ProText.r(14, weight: FontWeight.w600, color: ProColors.ink700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF9B1C1C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      'Cerrar sesión',
                      style: ProText.r(14, weight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
