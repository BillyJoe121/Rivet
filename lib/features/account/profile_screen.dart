import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla de perfil, preferencias y selector de rol (P-005 / P-044).
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
    final (name, email, initials) = switch (currentRole) {
      UserRole.client => ('Juan Camilo Pérez', 'juan.perez@ejemplo.com', 'JP'),
      UserRole.contractor => ('Carlos Mendoza', 'carlos.mendoza.pinturas@ejemplo.com', 'CM'),
      UserRole.supplier => ('FerreCasa Central', 'ventas@ferrecasacali.com', 'FC'),
    };

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Mi Cuenta',
        showBackButton: false,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Tarjeta de Identidad
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.brand700,
                  child: Text(
                    initials,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTypography.subheading),
                      Text(email, style: AppTypography.caption),
                      const SizedBox(height: 4),
                      AppBadge(
                        text: 'Rol Activo: ${currentRole.label}',
                        variant: AppBadgeVariant.brand,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Selector Rápido de Rol Activo
          Text('Cambiar Rol Activo en Rivet', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text('Permite probar y navegar la app desde las tres perspectivas.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ...UserRole.values.map((role) {
            final isCurrent = role == currentRole;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                isSelected: isCurrent,
                onTap: () => onSwitchRole(role),
                child: Row(
                  children: [
                    Icon(
                      switch (role) {
                        UserRole.client => Icons.home_work_outlined,
                        UserRole.contractor => Icons.format_paint_outlined,
                        UserRole.supplier => Icons.storefront_outlined,
                      },
                      color: isCurrent ? AppColors.brand700 : AppColors.ink700,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(role.label, style: AppTypography.subheading.copyWith(fontSize: 14)),
                          Text(role.description, style: AppTypography.caption),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      const Icon(Icons.check_circle, color: AppColors.brand700, size: 20),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: AppSpacing.xl),

          // Ajustes y Privacidad (P-044)
          Text('Privacidad y Consentimientos (P-044)', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            child: Column(
              children: [
                _buildSettingsRow(
                  Icons.auto_awesome_outlined,
                  'Minimización con IA',
                  'Activa (oculta caras y objetos)',
                ),
                const Divider(color: AppColors.line300),
                _buildSettingsRow(
                  Icons.lock_outline,
                  'Dirección privada',
                  'Solo visible al agendar visita',
                ),
                const Divider(color: AppColors.line300),
                _buildSettingsRow(
                  Icons.delete_outline,
                  'Eliminación de cuenta y datos',
                  'Solicitar según política',
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDestructive ? AppColors.danger700 : AppColors.ink700),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDestructive ? AppColors.danger700 : AppColors.ink900,
                  ),
                ),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.ink500),
        ],
      ),
    );
  }
}
