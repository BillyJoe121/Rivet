import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../home/widgets/kit/kit.dart';
import 'account_mock.dart';

/// "Cuenta, privacidad y preferencias" (22:146416): datos de la cuenta,
/// interruptores de visibilidad y consentimientos.
class PrivacyPreferencesScreen extends StatefulWidget {
  const PrivacyPreferencesScreen({super.key, required this.currentRole});

  final UserRole currentRole;

  @override
  State<PrivacyPreferencesScreen> createState() => _PrivacyPreferencesScreenState();
}

class _PrivacyPreferencesScreenState extends State<PrivacyPreferencesScreen> {
  bool _publicVisibility = true;
  bool _photoPrivacy = true;
  bool _aiConsent = true;

  @override
  Widget build(BuildContext context) {
    final profile = AccountProfile.forRole(widget.currentRole);

    return ProScreen(
      backgroundAsset: ProAssets.headerPrivacy,
      backgroundHeight: ProLayout.headerImageHeight,
      navWhenPushed: ProNavDestination.more,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Privacidad y preferencias',
            lucideChevron: true,
            height: 207,
            titleWidth: 270,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProCard(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      ProInitialsAvatar(
                        profile.initials,
                        size: 72,
                        textStyle: ProText.serif(28, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 33.6),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(profile.name, style: ProText.serif(21, color: ProColors.ink700, lineHeight: 25.2)),
                            const SizedBox(height: 6),
                            Text(profile.email, style: ProText.r(14, color: ProColors.ink700, lineHeight: 16.8)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                ProCard(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const ProOptionRow(
                        icon: LucideIcon.user,
                        title: 'Información de la cuenta',
                        subtitle: 'Nombre, correo y contacto',
                        lineHeight: 15.6,
                      ),
                      ProOptionRow(
                        icon: LucideIcon.mapPin,
                        title: 'Visibilidad pública',
                        subtitle: 'Mostrar solo zona aproximada',
                        trailing: ProToggle(
                          value: _publicVisibility,
                          onChanged: (v) => setState(() => _publicVisibility = v),
                        ),
                      ),
                      ProOptionRow(
                        icon: LucideIcon.image,
                        title: 'Privacidad de fotos',
                        subtitle: 'Permitir uso de fotos aprobadas',
                        trailing: ProToggle(
                          value: _photoPrivacy,
                          onChanged: (v) => setState(() => _photoPrivacy = v),
                        ),
                      ),
                      ProOptionRow(
                        icon: LucideIcon.sparkles,
                        title: 'Consentimiento de IA',
                        subtitle: 'Procesamiento de imágenes autorizado',
                        trailing: ProToggle(
                          value: _aiConsent,
                          onChanged: (v) => setState(() => _aiConsent = v),
                        ),
                      ),
                      const ProOptionRow(
                        icon: LucideIcon.bell,
                        title: 'Notificaciones',
                        subtitle: 'Mensajes, propuestas y fechas',
                      ),
                      const ProOptionRow(
                        icon: LucideIcon.lock,
                        title: 'Seguridad',
                        subtitle: 'Cambiar contraseña',
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const ProNote(
                  text: 'La dirección exacta y las fotos privadas nunca se comparten sin tu aprobación.',
                  icon: LucideIcon.info,
                ),
                const SizedBox(height: 25),
                ProPrimaryButton.large(
                  'Guardar preferencias',
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
