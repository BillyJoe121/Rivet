import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

// Flujo 1: Acceso y Roles
import '../onboarding/welcome_screen.dart';
import '../onboarding/role_selection_screen.dart';
import '../auth/forgot_password_screen.dart';

// Flujo 2: Proyectos y Medición
import '../projects/create_project_screen.dart';
import '../projects/project_detail_screen.dart';
import '../projects/my_projects_screen.dart';

// Flujo 3: Profesionales y Visitas
import '../contractors/contractors_directory_screen.dart';
import '../contractors/contractor_detail_screen.dart';
import '../contractors/contractor_visit_screen.dart';
import '../contractors/visit_payment_modal.dart';

// Flujo 4: Cotizaciones, Comparación y Negociación
import '../proposals/create_proposal_screen.dart';
import '../proposals/proposals_compare_screen.dart';
import '../proposals/proposal_detail_screen.dart';
import '../messaging/negotiation_chat_screen.dart';

// Flujo 5: Bodega, Materiales y Despachos
import '../supplier/materials_catalog_screen.dart';
import '../supplier/material_detail_screen.dart';
import '../supplier/add_catalog_product_screen.dart';
import '../supplier/pro_rate_authorization_screen.dart';
import '../supplier/materials_order_screen.dart';
import '../supplier/materials_delivery_screen.dart';

// Flujo 6: Pagos y Finanzas
import '../payments/project_payment_screen.dart';
import '../payments/payment_receipt_screen.dart';
import '../finance/financial_transactions_screen.dart';

// Flujo 7: Ejecución y Cierre
import '../execution/work_progress_screen.dart';
import '../execution/date_extension_modal.dart';

// Flujo 8: Reclamaciones, Incidencias y Cuenta
import '../disputes/cancellation_refund_screen.dart';
import '../disputes/create_incident_screen.dart';
import '../disputes/incident_detail_screen.dart';
import '../messaging/notifications_screen.dart';
import '../account/profile_screen.dart';

// Flujo 9: Administración Interna
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_dispute_resolution_screen.dart';

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
        subtitle: 'Trazabilidad y Cobertura 100% Rivet',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Banner de Cobertura
          AppCard(
            backgroundColor: AppColors.brandLight,
            borderColor: AppColors.brand700.withValues(alpha: 0.3),
            child: Row(
              children: [
                const Icon(Icons.verified, color: AppColors.brand700, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catálogo Completo Figma · 45 Pantallas', style: AppTypography.subheading),
                      const SizedBox(height: 2),
                      Text(
                        '100% de las pantallas maquetadas con componentes reutilizables y trazabilidad directa con requisitos funcionales (RF).',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 1. Acceso y Roles
          _buildGroupHeader('1. Acceso y Registro (P-001 a P-004)'),
          _buildTile(context, 'P-001', 'Acceso y Bienvenida de Marca', 'RF-002, RF-074', const WelcomeScreen()),
          _buildTile(context, 'P-002', 'Registro y Selección de Rol', 'RF-001, RF-074', const RoleSelectionScreen()),
          _buildTile(context, 'P-003', 'Recuperación de Acceso y Contraseña', 'RF-003', const ForgotPasswordScreen()),

          const SizedBox(height: AppSpacing.xl),

          // 2. Creación y Medición de Obra
          _buildGroupHeader('2. Medición y Creación de Obra (P-008 a P-016)'),
          _buildTile(context, 'P-008 / P-009', 'Crear Proyecto y Medir Superficies', 'RF-009, RF-010', const CreateProjectScreen()),
          _buildTile(context, 'P-010 / P-011', 'Captura de Fotos y Consentimiento IA', 'RF-011, RF-012, RF-008', const CreateProjectScreen()),
          _buildTile(context, 'P-012 / P-013', 'Revisión Minimizada y Dossier del Espacio', 'RF-013, RF-014, RF-016', ProjectDetailScreen(project: sampleProject)),
          _buildTile(context, 'P-014 / P-015', 'Rango Estimado y Publicación de Obra', 'RF-018, RF-034', ProjectDetailScreen(project: sampleProject)),
          _buildTile(context, 'P-016 / P-017', 'Mis Proyectos y Oportunidades en Cali', 'RF-009, RF-023, RF-035', const MyProjectsScreen()),
          _buildTile(context, 'P-018', 'Detalle de Obra para Cotizar', 'RF-016, RF-023, RF-029', ProjectDetailScreen(project: sampleProject, isContractorView: true)),

          const SizedBox(height: AppSpacing.xl),

          // 3. Profesionales y Visitas
          _buildGroupHeader('3. Pintores y Visitas Presenciales (P-006, P-019 a P-022)'),
          _buildTile(context, 'P-019', 'Directorio de Pintores Verificados', 'RF-024, RF-025', const ContractorsDirectoryScreen()),
          _buildTile(context, 'P-006', 'Perfil y Portafolio Profesional', 'RF-005, RF-007, RF-025', ContractorDetailScreen(contractor: sampleContractor)),
          _buildTile(context, 'P-020 / P-021', 'Solicitud y Agenda de Visita Presencial', 'RF-025, RF-026, RF-027', ContractorVisitScreen(contractor: sampleContractor)),
          _buildTile(context, 'P-022', 'Confirmación y Pago de Visita de Evaluación', 'RF-026, RF-033, RF-051', VisitPaymentModal(contractor: sampleContractor, scheduledDate: DateTime.now().add(const Duration(days: 2)))),

          const SizedBox(height: AppSpacing.xl),

          // 4. Cotizaciones, Comparación y Negociación
          _buildGroupHeader('4. Cotizaciones y Negociación (P-027 a P-031)'),
          _buildTile(context, 'P-027', 'Crear Propuesta Profesional (Contratista)', 'RF-029, RF-030, RF-031', CreateProposalScreen(project: sampleProject)),
          _buildTile(context, 'P-028', 'Detalle de Cotización con Desglose', 'RF-030, RF-033, RF-036', ProposalDetailScreen(proposal: sampleProposal)),
          _buildTile(context, 'P-029', 'Comparar Ofertas (Mano de Obra vs Materiales)', 'RF-030, RF-031, RF-035', const ProposalsCompareScreen()),
          _buildTile(context, 'P-030', 'Chat de Negociación y Aclaraciones', 'RF-020, RF-032, RF-074', NegotiationChatScreen(contractor: sampleContractor, projectTitle: sampleProject.title)),
          _buildTile(context, 'P-031', 'Resumen del Acuerdo de Trabajo', 'RF-033, RF-036, RF-037', ProposalDetailScreen(proposal: sampleProposal)),

          const SizedBox(height: AppSpacing.xl),

          // 5. Pagos y Finanzas
          _buildGroupHeader('5. Pagos y Finanzas (P-032, P-033, P-038)'),
          _buildTile(context, 'P-032', 'Pasarela de Pago de Prueba del Proyecto', 'RF-037, RF-038, RF-051', ProjectPaymentScreen(proposal: sampleProposal)),
          _buildTile(context, 'P-033', 'Comprobante y Verificación de Transacción', 'RF-044, RF-051, RF-055', PaymentReceiptScreen(proposal: sampleProposal, paymentMethod: 'PSE Bancolombia', transactionRef: 'RVT-2026-9042')),
          _buildTile(context, 'P-038', 'Movimientos Financieros y Liquidaciones', 'RF-044, RF-048, RF-050', const FinancialTransactionsScreen()),

          const SizedBox(height: AppSpacing.xl),

          // 6. Bodega, Materiales y Despachos
          _buildGroupHeader('6. Bodega y Proveedores (P-007, P-023 a P-026, P-036 a P-037)'),
          _buildTile(context, 'P-023', 'Catálogo de Bodega (Precios Cliente y Pro)', 'RF-017, RF-019, RF-020', const MaterialsCatalogScreen(isProRateView: true)),
          _buildTile(context, 'P-024', 'Ficha de Producto y Rendimiento en m²', 'RF-018, RF-022, RF-066', MaterialDetailScreen(material: sampleMaterial)),
          _buildTile(context, 'P-025', 'Agregar / Editar Material en Catálogo', 'RF-006, RF-021, RF-062', const AddCatalogProductScreen()),
          _buildTile(context, 'P-026', 'Autorización de Tarifa Pro a Contratista', 'RF-019, RF-065, RF-074', ProRateAuthorizationScreen(contractor: sampleContractor)),
          _buildTile(context, 'P-036', 'Orden Formal y Cotización de Materiales', 'RF-045, RF-046, RF-065', const MaterialsOrderScreen()),
          _buildTile(context, 'P-037', 'Recepción de Materiales y Checklist en Obra', 'RF-046, RF-047, RF-048', const MaterialsDeliveryScreen()),

          const SizedBox(height: AppSpacing.xl),

          // 7. Ejecución y Cierre
          _buildGroupHeader('7. Ejecución y Cierre de Obra (P-034, P-035, P-042)'),
          _buildTile(context, 'P-034', 'Seguimiento y Doble Confirmación de Entrega', 'RF-039, RF-040, RF-041', WorkProgressScreen(proposal: sampleProposal)),
          _buildTile(context, 'P-035', 'Solicitud y Acuerdo Mutuo de Prórroga', 'RF-041, RF-042, RF-068', DateExtensionModal(currentDeadline: DateTime.now().add(const Duration(days: 3)), projectTitle: sampleProject.title)),
          _buildTile(context, 'P-042', 'Calificación del Servicio y Reseña', 'RF-056', WorkProgressScreen(proposal: sampleProposal)),

          const SizedBox(height: AppSpacing.xl),

          // 8. Reclamaciones, Incidencias y Notificaciones
          _buildGroupHeader('8. Incidencias, Garantías y Notificaciones (P-039 a P-041, P-043, P-044)'),
          _buildTile(context, 'P-039', 'Solicitud de Cancelación y Devolución', 'RF-028, RF-052, RF-053', CancellationRefundScreen(projectTitle: sampleProject.title, contractorName: sampleContractor.name)),
          _buildTile(context, 'P-040', 'Crear Reporte de Incidencia en Obra', 'RF-043, RF-057, RF-074', CreateIncidentScreen(projectTitle: sampleProject.title, counterpartName: sampleContractor.name)),
          _buildTile(context, 'P-041', 'Seguimiento de Caso y Plazos de Mediación', 'RF-043, RF-058, RF-060', const IncidentDetailScreen()),
          _buildTile(context, 'P-043', 'Bandeja y Centro de Notificaciones', 'RF-020, RF-041, RF-068', const NotificationsScreen()),
          _buildTile(context, 'P-044', 'Ajustes de Cuenta y Consentimientos IA', 'RF-008, RF-067, RF-072', ProfileScreen(currentRole: currentRole, onSwitchRole: onRoleChanged)),

          const SizedBox(height: AppSpacing.xl),

          // 9. Administración Interna
          _buildGroupHeader('9. Administración Interna (P-045 a P-047)'),
          _buildTile(context, 'P-045', 'Panel Administrativo y Supervisión General', 'RF-059, RF-063, RF-074', const AdminDashboardScreen()),
          _buildTile(context, 'P-046 / P-047', 'Resolución Fundada de Casos y Tarifas', 'RF-049, RF-061, RF-073', const AdminDisputeResolutionScreen()),
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

  Widget _buildTile(
    BuildContext context,
    String code,
    String title,
    String rf,
    Widget screen,
  ) {
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
