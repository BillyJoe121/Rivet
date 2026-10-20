import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'account_mock.dart';
import 'privacy_preferences_screen.dart';
import 'widgets/account_role_sheet.dart';

/// "Mi perfil": datos personales del usuario. Tocar el avatar abre el
/// selector de rol activo.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.currentRole,
    required this.onSwitchRole,
  });

  final UserRole currentRole;
  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final profile = AccountProfile.forRole(currentRole);
    void openPreferences() => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PrivacyPreferencesScreen(currentRole: currentRole)),
        );

    return ProScreen(
      backgroundAsset: ProAssets.headerLivingRoom,
      navWhenPushed: ProNavDestination.more,
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
        child: ProPrimaryButton.large('Guardar cambios', onTap: () => Navigator.of(context).maybePop()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Mi perfil',
            lucideChevron: true,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
          ),
          const SizedBox(height: 31),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ProCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Cambiar rol activo',
                        child: GestureDetector(
                          onTap: () => showAccountRoleSheet(
                            context,
                            currentRole: currentRole,
                            onSwitchRole: onSwitchRole,
                          ),
                          child: ProInitialsAvatar(
                            profile.initials,
                            size: 88,
                            textStyle: ProText.serif(29, weight: FontWeight.w400, color: ProColors.surface0, lineHeight: 34.8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          profile.name,
                          style: ProText.serif(22, color: ProColors.ink700, lineHeight: 26.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ProChip(
                    '✓ Perfil completo',
                    background: ProColors.successLight,
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    textStyle: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                  ),
                  const SizedBox(height: 14),
                  Text('Información personal', style: ProText.serif(19, color: ProColors.ink700, lineHeight: 22.8)),
                  const SizedBox(height: 14),
                  Column(
                    spacing: 14,
                    children: [
                      for (final (icon, title, value) in [
                        (LucideIcon.user, 'Nombre visible', profile.name),
                        (LucideIcon.mail, 'Correo electrónico', profile.email),
                        (LucideIcon.phone, 'Número de contacto', profile.phone),
                        (LucideIcon.mapPin, 'Ciudad / zona', profile.zone),
                      ])
                        SizedBox(
                          height: 40,
                          child: ProOptionRow(icon: icon, title: title, subtitle: value, onTap: openPreferences),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const ProNote(
                    text: 'Tu dirección exacta se mantiene privada. Solo compartiremos tu zona con profesionales y '
                        'proveedores.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
