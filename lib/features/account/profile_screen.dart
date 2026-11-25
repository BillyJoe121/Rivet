import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/design_system/design_system.dart';
import '../../core/models/models.dart';
import '../agreements/payout_account_screen.dart';
import '../auth/presentation/bloc/auth/auth_bloc.dart';
import '../onboarding/welcome_screen.dart';
import '../under_construction/under_construction_screen.dart';
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
    final realUser = context.select((AuthBloc bloc) => bloc.state.user);

    // Solo datos del usuario real; sin sesión cargada los campos quedan vacíos
    // en lugar de mostrar datos de ejemplo.
    final displayName = realUser?.fullName ?? '';
    final displayEmail = realUser?.email ?? '';
    final displayPhone = realUser?.phone ?? '';
    final displayZone = (realUser?.zone.isNotEmpty ?? false)
        ? realUser!.zone
        : 'Sin zona registrada';

    final initials = displayName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();

    return RivetScaffold(
      title: 'Mi perfil',
      showBackButton: true,
      onBack: widget.onBack,
      backgroundImagePath: AppImages.headerGreenCream,
      bottomBar: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              text: 'Guardar cambios',
              showChevron: true,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _handleSignOut,
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
                size: 20,
              ),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 31, 22, 22),
        child: AppCard(
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
                      style: AppTypography.proportional(
                        19,
                        family: AppTypography.serif,
                        weight: FontWeight.w600,
                        color: AppColors.ink700,
                        lineHeight: 22.8,
                      ),
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
                    child: Text(
                      'Editar',
                      style: AppTypography.labelStrongProportional.copyWith(
                        color: AppColors.brand700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Column(
                spacing: 8,
                children: [
                  for (final (icon, title, value) in [
                    (LucideIcons.user, 'Nombre visible', displayName),
                    (LucideIcons.mail, 'Correo electrónico', displayEmail),
                    (LucideIcons.phone, 'Número de contacto', displayPhone),
                    (LucideIcons.mapPin, 'Ciudad / zona', displayZone),
                  ])
                    AppListTile(
                      leadingIcon: icon,
                      title: title,
                      subtitle: value,
                      showChevron: false,
                    ),
                  if (widget.currentRole == UserRole.contractor)
                    AppListTile(
                      leadingIcon: LucideIcons.creditCard,
                      title: 'Cuenta para recibir pagos',
                      subtitle: 'Datos bancarios enmascarados',
                      onTap: () => AppNavigator.push(
                        context,
                        PayoutAccountScreen.withBloc(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              const AppInfoBanner(
                message:
                    'Tu dirección exacta se mantiene privada. Solo compartiremos tu zona con profesionales verificados.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
