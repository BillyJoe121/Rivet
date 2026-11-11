import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/models.dart';
import '../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../core/design_system/design_system.dart';
import '../onboarding/welcome_screen.dart';
import '../under_construction/under_construction_screen.dart';
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
    this.onBack,
  });

  final UserRole currentRole;
  final ValueChanged<UserRole> onSwitchRole;

  /// Vuelve a Inicio. Como página raíz del shell no hay ruta que cerrar, así
  /// que el botón volver delega aquí; sin él usa el comportamiento por defecto.
  final VoidCallback? onBack;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _handleSignOut() async {
    final confirmed = await ConfirmSignOutDialog.show(context);

    if (confirmed == true && mounted) {
      context.read<AuthBloc>().add(const AuthSignOutRequested());
      AppNavigator.pushAndRemoveUntil(context, const WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackMock = AccountProfile.forRole(widget.currentRole);
    final realUser = context.select((AuthBloc bloc) => bloc.state.user);

    // Solo datos del usuario real; sin sesión cargada los campos quedan vacíos
    // en lugar de mostrar el perfil de ejemplo.
    final displayName = realUser?.fullName ?? '';
    final displayEmail = realUser?.email ?? '';
    final displayPhone = realUser?.phone ?? '';

    final initials = displayName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();

    return ProScreen(
      backgroundAsset: AppImages.headerGreenCream,
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
          ProBackHeader(
            title: 'Mi perfil',
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            onBack: widget.onBack,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Información personal',
                          style: AppTypography.proportional(19, family: AppTypography.serif, weight: FontWeight.w600, color: AppColors.ink700, lineHeight: 22.8),
                        ),
                      ),
                      // Provisional: la edición real reemplazará esta pantalla.
                      TextButton(
                        onPressed: () => AppNavigator.push(
                          context,
                          const UnderConstructionScreen(section: 'Editar perfil'),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.brand700,
                          minimumSize: const Size(48, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('Editar', style: AppTypography.labelStrongProportional.copyWith(color: AppColors.brand700)),
                      ),
                    ],
                  ),
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
                    text: 'Tu dirección exacta se mantiene privada. Solo compartiremos tu zona con profesionales verificados.',
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
