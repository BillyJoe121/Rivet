import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'agreements_module.dart';
import 'project_payment_screen.dart';

export 'payout_account_screen.dart';
export 'project_payment_screen.dart';
export 'proposals_compare_screen.dart';

/// Resumen formal de acuerdo mutuo de obra antes del pago de anticipo (frame 22-145284).
class AgreementSummaryScreen extends StatelessWidget {
  const AgreementSummaryScreen({
    super.key,
    this.proposal,
    this.agreementId,
    this.projectTitle = 'Pintura y acabados residenciales',
    this.asClient = true,
  });

  final Proposal? proposal;
  final String? agreementId;
  final String projectTitle;
  final bool asClient;

  static Widget withBloc({
    required Proposal proposal,
    String projectTitle = 'Pintura y acabados residenciales',
    bool asClient = true,
  }) {
    return BlocProvider<AgreementsBloc>(
      create: (context) =>
          AgreementsBloc.fromRepository(context.read<AgreementRepository>())
            ..add(
              PrepareAgreementRequested(
                projectId: proposal.projectId,
                projectTitle: projectTitle,
                proposal: proposal,
              ),
            ),
      child: AgreementSummaryScreen(
        proposal: proposal,
        projectTitle: projectTitle,
        asClient: asClient,
      ),
    );
  }

  static Widget withAgreementId({
    required String agreementId,
    bool asClient = false,
  }) {
    return BlocProvider<AgreementsBloc>(
      create: (context) =>
          AgreementsBloc.fromRepository(context.read<AgreementRepository>())
            ..add(LoadAgreementById(agreementId)),
      child: AgreementSummaryScreen(
        agreementId: agreementId,
        asClient: asClient,
      ),
    );
  }

  static Route<void> route({
    required Proposal proposal,
    String projectTitle = 'Pintura y acabados residenciales',
    bool asClient = true,
  }) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(
        proposal: proposal,
        projectTitle: projectTitle,
        asClient: asClient,
      ),
    );
  }

  static Route<void> routeForAgreement({
    required String agreementId,
    bool asClient = false,
  }) {
    return RivetPageRoute<void>(
      builder: (_) => withAgreementId(
        agreementId: agreementId,
        asClient: asClient,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgreementsBloc, AgreementsState>(
      listener: (context, state) {
        if (state.status == AgreementsStatus.failure &&
            state.agreement != null &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;
        final currentPartyAccepted = agreement == null
            ? false
            : (asClient
                  ? agreement.clientAcceptedAt != null
                  : agreement.contractorAcceptedAt != null);

        return RivetScaffold(
          title: 'Acuerdo del\ntrabajo',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.documents,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : _buildFooter(context, state, agreement, currentPartyAccepted),
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Preparando acuerdo')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar el acuerdo'),
                  message:
                      state.errorMessage ??
                      'No fue posible construir el resumen del acuerdo.',
                )
              else ...[
                _AgreementOverviewCard(agreement: agreement),
                const SizedBox(height: AppSpacing.md),
                _MutualAcceptanceCard(
                  agreement: agreement,
                  asClient: asClient,
                  currentPartyAccepted: currentPartyAccepted,
                ),
                const SizedBox(height: AppSpacing.md),
                _MilestonesCard(agreement: agreement),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AgreementsState state,
    WorkAgreement agreement,
    bool currentPartyAccepted,
  ) {
    if (!currentPartyAccepted) {
      final termsChecked = asClient ? agreement.clientAcceptedTerms : true;
      return AppButton(
        text: asClient
            ? 'Aceptar acuerdo como cliente'
            : 'Aceptar acuerdo como contratista',
        isLoading: state.isAccepting,
        showChevron: true,
        onPressed: termsChecked
            ? () => context.read<AgreementsBloc>().add(
                  AcceptAgreementRequested(asClient: asClient),
                )
            : null,
      );
    }
    if (asClient) {
      return AppButton(
        text: 'Continuar al pago de anticipo',
        showChevron: true,
        onPressed: () => AppNavigator.push(
          context,
          BlocProvider<AgreementsBloc>.value(
            value: context.read<AgreementsBloc>(),
            child: const ProjectPaymentScreen(),
          ),
        ),
      );
    }
    return AppButton(
      text: agreement.isMutuallyAccepted
          ? 'Acuerdo activo · Volver'
          : 'Aceptación registrada · Volver',
      variant: AppButtonVariant.outline,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class _AgreementOverviewCard extends StatelessWidget {
  const _AgreementOverviewCard({required this.agreement});

  final WorkAgreement agreement;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBadge(
            text: agreement.status.label,
            variant: agreement.status == AgreementStatus.active
                ? AppBadgeVariant.brand
                : AppBadgeVariant.warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(agreement.projectTitle, style: AppTypography.sectionTitle),
          const SizedBox(height: 4),
          Text(
            'Contratista: ${agreement.contractorName}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          AppSpecRow(
            icon: LucideIcons.hammer,
            label: 'Mano de obra acordada',
            value: '\$ ${formatCop(agreement.laborAmountCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.paintBucket,
            label: 'Materiales de la Bodega Rivet',
            value: '\$ ${formatCop(agreement.materialsAmountCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.clock,
            label: 'Plazo de ejecución',
            value: '${agreement.estimatedDays} días hábiles',
          ),
          AppSpecRow(
            icon: LucideIcons.coins,
            label: 'Total del acuerdo',
            value: '\$ ${formatCop(agreement.totalAmountCop)} COP',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _MutualAcceptanceCard extends StatelessWidget {
  const _MutualAcceptanceCard({
    required this.agreement,
    required this.asClient,
    required this.currentPartyAccepted,
  });

  final WorkAgreement agreement;
  final bool asClient;
  final bool currentPartyAccepted;

  @override
  Widget build(BuildContext context) {
    final clientDone = agreement.clientAcceptedAt != null;
    final contractorDone = agreement.contractorAcceptedAt != null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aceptación mutua', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.sm),
          AppSpecRow(
            icon: clientDone ? LucideIcons.circleCheck : LucideIcons.clock,
            label: 'Propietario / Cliente',
            value: clientDone ? 'Aceptado' : 'Pendiente',
          ),
          AppSpecRow(
            icon: contractorDone ? LucideIcons.circleCheck : LucideIcons.clock,
            label: 'Contratista',
            value: contractorDone ? 'Aceptado' : 'Pendiente',
            showDivider: asClient && !currentPartyAccepted,
          ),
          if (asClient && !currentPartyAccepted)
            AppListTile(
              title: 'Acepto el alcance, el plazo y las condiciones del acuerdo',
              subtitle: 'Requerido para activar el acuerdo y pasar al anticipo',
              showDivider: false,
              showChevron: false,
              trailing: AppSwitch(
                value: agreement.clientAcceptedTerms,
                onChanged: (value) {
                  context.read<AgreementsBloc>().add(
                        ToggleAgreementTermsAccepted(value),
                      );
                },
              ),
              onTap: () {
                context.read<AgreementsBloc>().add(
                      ToggleAgreementTermsAccepted(
                        !agreement.clientAcceptedTerms,
                      ),
                    );
              },
            ),
        ],
      ),
    );
  }
}

class _MilestonesCard extends StatelessWidget {
  const _MilestonesCard({required this.agreement});

  final WorkAgreement agreement;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alcance e hitos del trabajo', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.sm),
          for (final milestone in agreement.milestones)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: AppColors.brand700,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(milestone, style: AppTypography.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
