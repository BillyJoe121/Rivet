import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../home/app_shell.dart';

/// Pantalla interactiva de selección de rol (P-001 / P-004).
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole _selectedRole = UserRole.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: 'Selección de Rol',
        subtitle: 'Elige cómo deseas experimentar Rivet',
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Cuál es tu rol en la obra?',
                style: AppTypography.pageTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Puedes cambiar de rol en cualquier momento desde el perfil o el explorador.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Lista de Tarjetas de Rol
              Expanded(
                child: ListView(
                  children: UserRole.values.map((role) {
                    final isSelected = _selectedRole == role;
                    final (icon, tag) = switch (role) {
                      UserRole.client => (Icons.home_work_outlined, 'Quiero cotizar mi casa'),
                      UserRole.contractor => (Icons.format_paint_outlined, 'Ofrezco servicios de pintura'),
                      UserRole.supplier => (Icons.storefront_outlined, 'Vendo pinturas e insumos'),
                    };

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppCard(
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedRole = role),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.brand700 : AppColors.surfaceSubtle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? Colors.white : AppColors.ink700,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(role.label, style: AppTypography.subheading),
                                      const Spacer(),
                                      if (isSelected)
                                        const Icon(Icons.check_circle, color: AppColors.brand700, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tag,
                                    style: AppTypography.caption.copyWith(
                                      color: isSelected ? AppColors.brand700 : AppColors.ink500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(role.description, style: AppTypography.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              AppButton(
                text: 'Continuar como ${_selectedRole.label}',
                trailingIcon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppShell(initialRole: _selectedRole),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
