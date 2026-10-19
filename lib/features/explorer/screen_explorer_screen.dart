import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../onboarding/welcome_screen.dart';
import '../onboarding/role_selection_screen.dart';
import '../projects/create_project_screen.dart';
import '../projects/project_detail_screen.dart';
import '../projects/my_projects_screen.dart';
import '../contractors/contractors_directory_screen.dart';
import '../contractors/contractor_detail_screen.dart';
import '../contractors/contractor_visit_screen.dart';
import '../proposals/proposals_compare_screen.dart';
import '../proposals/create_proposal_screen.dart';
import '../proposals/proposal_detail_screen.dart';
import '../supplier/materials_catalog_screen.dart';
import '../supplier/material_detail_screen.dart';
import '../execution/work_progress_screen.dart';
import '../account/profile_screen.dart';

/// Explorador interactivo de las 45 pantallas de Rivet y su trazabilidad con requisitos (RF).
class ScreenExplorerScreen extends StatelessWidget {
  const ScreenExplorerScreen({
    super.key,
    required this.currentRole,
    required this.onRoleChanged,
  });

  final UserRole currentRole;
  final ValueChanged<UserRole> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    final sampleProject = MockData.projects.first;
    final sampleContractor = MockData.contractors.first;
    final sampleProposal = MockData.proposals.first;
    final sampleMaterial = MockData.materials.first;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Explorador 45 Pantallas',
        subtitle: 'Trazabilidad y Catálogo del Prototipo',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Banner Explicativo
          AppCard(
            backgroundColor: AppColors.brandLight,
            borderColor: AppColors.brand700.withValues(alpha: 0.3),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: AppColors.brand700, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trazabilidad Integral Figma · Flutter', style: AppTypography.subheading),
                      const SizedBox(height: 2),
                      Text(
                        'Accede a cada pantalla del prototipo y verifica su correspondencia con los documentos funcionales.',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 1: Acceso y Roles
          _buildGroupHeader('1. Acceso y Roles (P-001 a P-004)'),
          _buildScreenTile(
            context,
            code: 'P-001 / P-004',
            title: 'Bienvenida e Inicio de Marca',
            rf: 'RF-002, RF-009',
            screen: const WelcomeScreen(),
          ),
          _buildScreenTile(
            context,
            code: 'P-002 / P-004',
            title: 'Selección de Rol (Cliente / Contratista / Bodega)',
            rf: 'RF-001, RF-074',
            screen: const RoleSelectionScreen(),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 2: Medición y Creación de Obra
          _buildGroupHeader('2. Creación y Medición de Obra (P-008 a P-015)'),
          _buildScreenTile(
            context,
            code: 'P-008 / P-009',
            title: 'Crear Proyecto y Medir Superficies',
            rf: 'RF-009, RF-010, RF-011',
            screen: const CreateProjectScreen(),
          ),
          _buildScreenTile(
            context,
            code: 'P-011 / P-012',
            title: 'Autorización de IA y Minimización de Fotos',
            rf: 'RF-008, RF-012, RF-013, RF-014',
            screen: const CreateProjectScreen(),
          ),
          _buildScreenTile(
            context,
            code: 'P-013 / P-014',
            title: 'Dossier, Estimación de Insumos y Publicación',
            rf: 'RF-016, RF-018, RF-034',
            screen: ProjectDetailScreen(project: sampleProject),
          ),
          _buildScreenTile(
            context,
            code: 'P-016',
            title: 'Mis Proyectos (Listado y Estados)',
            rf: 'RF-009, RF-035, RF-068',
            screen: const MyProjectsScreen(),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 3: Directorio de Pintores y Visitas
          _buildGroupHeader('3. Pintores y Visitas (P-006, P-019 a P-022)'),
          _buildScreenTile(
            context,
            code: 'P-019',
            title: 'Buscar y Filtrar Pintores Verificados',
            rf: 'RF-024, RF-025',
            screen: const ContractorsDirectoryScreen(),
          ),
          _buildScreenTile(
            context,
            code: 'P-006',
            title: 'Perfil y Portafolio del Contratista',
            rf: 'RF-005, RF-007, RF-025',
            screen: ContractorDetailScreen(contractor: sampleContractor),
          ),
          _buildScreenTile(
            context,
            code: 'P-020 / P-021',
            title: 'Solicitud y Agenda de Visita Presencial',
            rf: 'RF-025, RF-026, RF-027, RF-028',
            screen: ContractorVisitScreen(contractor: sampleContractor),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 4: Cotizaciones y Comparación
          _buildGroupHeader('4. Cotizaciones y Acuerdo (P-027 a P-032)'),
          _buildScreenTile(
            context,
            code: 'P-027',
            title: 'Crear Propuesta Profesional (Contratista)',
            rf: 'RF-029, RF-030, RF-031',
            screen: CreateProposalScreen(project: sampleProject),
          ),
          _buildScreenTile(
            context,
            code: 'P-029',
            title: 'Comparador de Ofertas (Mano de Obra vs Materiales)',
            rf: 'RF-030, RF-031, RF-035',
            screen: const ProposalsCompareScreen(),
          ),
          _buildScreenTile(
            context,
            code: 'P-028 / P-031 / P-032',
            title: 'Detalle de Cotización, Acuerdo y Pago Simulado',
            rf: 'RF-033, RF-036, RF-037, RF-038',
            screen: ProposalDetailScreen(proposal: sampleProposal),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 5: Bodega y Materiales
          _buildGroupHeader('5. Bodega y Proveedores (P-007, P-023 a P-026)'),
          _buildScreenTile(
            context,
            code: 'P-023 / P-026',
            title: 'Catálogo de Bodega con Tarifa Profesional',
            rf: 'RF-017, RF-019, RF-020, RF-065',
            screen: const MaterialsCatalogScreen(isProRateView: true),
          ),
          _buildScreenTile(
            context,
            code: 'P-024',
            title: 'Ficha de Producto y Rendimiento Técnico',
            rf: 'RF-018, RF-019, RF-022, RF-066',
            screen: MaterialDetailScreen(material: sampleMaterial),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 6: Ejecución y Cierre
          _buildGroupHeader('6. Ejecución y Cierre (P-034, P-035, P-042)'),
          _buildScreenTile(
            context,
            code: 'P-034 / P-042',
            title: 'Seguimiento, Doble Confirmación y Calificación',
            rf: 'RF-039, RF-040, RF-041, RF-056',
            screen: WorkProgressScreen(proposal: sampleProposal),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Grupo 7: Cuenta y Preferencias
          _buildGroupHeader('7. Cuenta y Privacidad (P-005, P-044)'),
          _buildScreenTile(
            context,
            code: 'P-005 / P-044',
            title: 'Ajustes de Perfil, Privacidad y Cambio de Rol',
            rf: 'RF-004, RF-008, RF-067, RF-072',
            screen: ProfileScreen(currentRole: currentRole, onSwitchRole: onRoleChanged),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.subheading.copyWith(fontSize: 16, color: AppColors.brand700),
      ),
    );
  }

  Widget _buildScreenTile(
    BuildContext context, {
    required String code,
    required String title,
    required String rf,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.line300),
              ),
              child: Text(code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.ink900)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.subheading.copyWith(fontSize: 14)),
                  Text(rf, style: AppTypography.caption.copyWith(color: AppColors.ink500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.ink500),
          ],
        ),
      ),
    );
  }
}
