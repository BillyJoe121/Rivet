import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../home/app_shell.dart';
import 'role_selection_screen.dart';

/// Pantalla de bienvenida y punto de entrada al prototipo Rivet.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              // Cabecera con Marca
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.brand700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'R',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Text(
                    'Rivet',
                    style: AppTypography.pageTitle.copyWith(fontSize: 28),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Cotizaciones para tu obra',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink700,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Tarjeta Ilustrada Hero
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMd)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'Fondos/Salón Minimalista en Verde y Crema.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.brandLight,
                            child: const Icon(Icons.format_paint, size: 48, color: AppColors.brand700),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBadge(
                            text: 'Transparente y sin fricción',
                            variant: AppBadgeVariant.brand,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Conecta tu obra con una cotización mejor definida',
                            style: AppTypography.subheading.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: AppSpacing.xs + 2),
                          Text(
                            'Organiza fotos, medidas, materiales y mano de obra para que puedas comparar el alcance real antes de contratar.',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Botones de acción principales
              AppButton(
                text: 'Comenzar como Cliente',
                icon: Icons.person_outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppShell(initialRole: UserRole.client),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Explorar roles y accesos',
                variant: AppButtonVariant.outline,
                icon: Icons.switch_account_outlined,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoleSelectionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Garantías y notas de confianza
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: AppColors.ink500),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Fotos privadas · Cotizaciones sin costo oculto',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
