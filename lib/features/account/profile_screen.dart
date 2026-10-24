import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/app_page_route.dart';
import '../auth/auth_service.dart';
import '../auth/domain/entities/rivet_user.dart';
import '../home/widgets/kit/kit.dart';
import '../onboarding/welcome_screen.dart';
import 'account_mock.dart';
import 'widgets/account_profile_widgets.dart';
import 'widgets/account_role_sheet.dart';

/// "Mi perfil": datos personales del usuario conectado a Supabase.
/// Muestra los datos reales del usuario autenticado y permite cerrar sesión.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.currentRole,
    required this.onSwitchRole,
  });

  final UserRole currentRole;
  final ValueChanged<UserRole> onSwitchRole;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RivetUser? _realUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await AuthService.instance.getCurrentUser();
      if (mounted) {
        setState(() {
          _realUser = user;
        });
      }
    } catch (_) {}
  }

  Future<void> _handleSignOut() async {
    final confirmed = await ConfirmSignOutDialog.show(context);

    if (confirmed == true) {
      await AuthService.instance.signOut();
      if (!mounted) return;
      AppNavigator.pushAndRemoveUntil(context, const WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackMock = AccountProfile.forRole(widget.currentRole);

    final displayName = (_realUser?.fullName.isNotEmpty ?? false)
        ? _realUser!.fullName
        : fallbackMock.name;
    final displayEmail = (_realUser?.email.isNotEmpty ?? false)
        ? _realUser!.email
        : fallbackMock.email;
    final displayPhone = (_realUser?.phone.isNotEmpty ?? false)
        ? _realUser!.phone
        : fallbackMock.phone;

    final initials = displayName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();

    return ProScreen(
      backgroundAsset: ProAssets.headerLivingRoom,
      navWhenPushed: ProNavDestination.more,
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProPrimaryButton.large('Guardar cambios', onTap: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _handleSignOut,
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
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
                  ProfileHeaderCard(
                    initials: initials,
                    displayName: displayName,
                    roleTitle: widget.currentRole == UserRole.contractor
                        ? 'Contratista profesional'
                        : 'Cliente propietario',
                    onTapAvatar: () => showAccountRoleSheet(
                      context,
                      currentRole: widget.currentRole,
                      onSwitchRole: widget.onSwitchRole,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Información personal', style: ProText.serif(19, color: ProColors.ink700, lineHeight: 22.8)),
                  const SizedBox(height: 14),
                  Column(
                    spacing: 14,
                    children: [
                      for (final (icon, title, value) in [
                        (LucideIcon.user, 'Nombre visible', displayName),
                        (LucideIcon.mail, 'Correo electrónico', displayEmail),
                        (LucideIcon.phone, 'Número de contacto', displayPhone),
                        (LucideIcon.mapPin, 'Ciudad / zona', fallbackMock.zone),
                      ])
                        SizedBox(
                          height: 40,
                          child: ProOptionRow(icon: icon, title: title, subtitle: value, trailing: null),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const ProNote(
                    text: 'Tu dirección exacta se mantiene privada. Solo compartiremos tu zona con profesionales garantizados.',
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
