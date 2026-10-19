import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../home/app_shell.dart';
import 'role_selection_screen.dart';

/// Pantalla de bienvenida con identidad editorial, silueta orgánica y atmósfera biofílica.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      showBackButton: false,
      backgroundImagePath: 'Fondos/Salón Minimalista en Verde y Crema.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        children: [
          const SizedBox(height: AppSpacing.lg),

          // Logo y Slogan Editorial
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brand700,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Rivet',
                style: AppTypography.editorialHeading.copyWith(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Cotizaciones y renovación para tu hogar',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.ink700,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Tarjeta Hero Ilustrada con Radio 20px y Sombra Difusa
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      'Fondos/Salón Minimalista en Verde y Crema.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.brandLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Transparente y sin fricción',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.brand700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Conecta tu obra con una cotización mejor definida',
                        style: AppTypography.sectionTitle.copyWith(fontSize: 19),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2),
                      Text(
                        'Organiza fotos, medidas, materiales y mano de obra para comparar el alcance real antes de contratar.',
                        style: AppTypography.bodySmall.copyWith(height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Botones de acción en Píldora Elegante
          AppButton(
            text: 'Comenzar como Cliente',
            trailingIcon: Icons.chevron_right,
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
            variant: AppButtonVariant.secondary,
            trailingIcon: Icons.chevron_right,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoleSelectionScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Garantías y notas de confianza
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 16, color: AppColors.brand700),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Fotos privadas · Cotizaciones sin costo oculto',
                style: AppTypography.caption.copyWith(color: AppColors.ink700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
