import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'agreements_module.dart';

export 'proposals_compare_screen.dart';

/// Resumen formal de acuerdo de obra antes del pago de prueba (P-031).
class AgreementSummaryScreen extends StatefulWidget {
  const AgreementSummaryScreen({
    super.key,
    required this.proposal,
    this.projectTitle = 'Pintura y acabados residenciales',
    this.agreementsBloc,
  });

  final Proposal proposal;
  final String projectTitle;
  final AgreementsBloc? agreementsBloc;

  @override
  State<AgreementSummaryScreen> createState() => _AgreementSummaryScreenState();
}

class _AgreementSummaryScreenState extends State<AgreementSummaryScreen> {
  late final AgreementsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.agreementsBloc ??
        AgreementsBloc(
          AgreementsService.instance.prepareAgreementUseCase,
          AgreementsService.instance.processSimulatedPaymentUseCase,
          AgreementsService.instance.confirmWorkCompletionUseCase,
        );
    _bloc.add(
      PrepareAgreementRequested(
        projectId: widget.proposal.projectId,
        projectTitle: widget.projectTitle,
        proposal: widget.proposal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AgreementsBloc>.value(
      value: _bloc,
      child: BlocBuilder<AgreementsBloc, AgreementsState>(
        builder: (context, state) {
          final agreement = state.agreement;
          return RivetScaffold(
            title: 'Acuerdo del\ntrabajo',
            showBackButton: true,
            backgroundImagePath: AppHeroImages.documents,
            body: AppPageBody(
              footer: agreement == null
                  ? null
                  : AppButton(
                      text: 'Continuar al pago simulado',
                      showChevron: true,
                      onPressed: agreement.clientAcceptedTerms
                          ? () => AppNavigator.push(
                              context,
                              BlocProvider<AgreementsBloc>.value(
                                value: _bloc,
                                child: const SimulatedPaymentScreen(),
                              ),
                            )
                          : null,
                    ),
              children: [
                if (state.isLoading && agreement == null)
                  const AppLoadingState(label: 'Preparando acuerdo')
                else if (agreement == null)
                  AppErrorState(
                    message: state.errorMessage ??
                        'No fue posible construir el resumen del acuerdo.',
                  )
                else ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agreement.projectTitle,
                          style: AppTypography.sectionTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contratista: ${agreement.contractorName}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSpecRow(
                          icon: LucideIcons.hammer,
                          label: 'Mano de obra acordada',
                          value:
                              '\$ ${formatCop(agreement.laborAmountCop)} COP',
                        ),
                        AppSpecRow(
                          icon: LucideIcons.paintBucket,
                          label: 'Materiales de la Bodega Rivet',
                          value:
                              '\$ ${formatCop(agreement.materialsAmountCop)} COP',
                        ),
                        AppSpecRow(
                          icon: LucideIcons.clock,
                          label: 'Plazo de ejecución',
                          value: '${agreement.estimatedDays} días hábiles',
                        ),
                        AppSpecRow(
                          icon: LucideIcons.coins,
                          label: 'Total del acuerdo',
                          value:
                              '\$ ${formatCop(agreement.totalAmountCop)} COP',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alcance e hitos del trabajo',
                          style: AppTypography.subheading,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final milestone in agreement.milestones)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
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
                                  child: Text(
                                    milestone,
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(color: AppColors.line300),
                        AppListTile(
                          title:
                              'Acepto el alcance, el plazo y las condiciones del acuerdo de obra',
                          subtitle:
                              'Habilita el paso al pago simulado de prueba',
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
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Pantalla de pago simulado de prueba (P-032).
class SimulatedPaymentScreen extends StatelessWidget {
  const SimulatedPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgreementsBloc, AgreementsState>(
      listener: (context, state) {
        if (state.status == AgreementsStatus.paymentSuccess ||
            state.status == AgreementsStatus.paymentFailed) {
          final bloc = context.read<AgreementsBloc>();
          AppNavigator.pushReplacement(
            context,
            BlocProvider<AgreementsBloc>.value(
              value: bloc,
              child: const PaymentResultScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;
        return RivetScaffold(
          title: 'Pago\nsimulado',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.trust,
          body: AppPageBody(
            footer: agreement == null
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        text:
                            'Confirmar Pago simulado (\$ ${formatCop(agreement.totalAmountCop)})',
                        isLoading: state.isProcessingPayment,
                        showChevron: true,
                        onPressed: () {
                          context.read<AgreementsBloc>().add(
                            const SubmitSimulatedPayment(),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'Simular rechazo de pago',
                        variant: AppButtonVariant.outline,
                        onPressed: state.isProcessingPayment
                            ? null
                            : () {
                                context.read<AgreementsBloc>().add(
                                  const SubmitSimulatedPayment(
                                    simulateFailure: true,
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBadge(
                      text: 'Pago simulado · Entorno de prueba',
                      variant: AppBadgeVariant.warning,
                      icon: LucideIcons.flaskConical,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const AppInfoBanner(
                      message:
                          'Pago simulado: esta operación no realiza cobros bancarios reales. Sirve para recorrer el flujo completo del proyecto.',
                    ),
                    if (agreement != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Método de prueba',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final method in SimulatedPaymentMethod.values)
                        AppListTile(
                          title: method.label,
                          subtitle: 'Pago simulado instantáneo',
                          leadingIcon: LucideIcons.creditCard,
                          showChevron: false,
                          trailing: Icon(
                            agreement.selectedMethod == method
                                ? LucideIcons.circleCheck
                                : LucideIcons.circle,
                            color: AppColors.brand700,
                            size: 18,
                          ),
                          onTap: () {
                            context.read<AgreementsBloc>().add(
                              SelectSimulatedPaymentMethod(method),
                            );
                          },
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Resultado del pago simulado y seguimiento/cierre del trabajo (P-033, P-034).
class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgreementsBloc, AgreementsState>(
      builder: (context, state) {
        final agreement = state.agreement;
        final failed = state.status == AgreementsStatus.paymentFailed;
        final completed = state.status == AgreementsStatus.workCompleted ||
            (agreement?.workCompletedConfirmed ?? false);

        return RivetScaffold(
          title: failed
              ? 'Pago\nrechazado'
              : (completed ? 'Obra\nfinalizada' : 'Comprobante\nde pago'),
          showBackButton: true,
          backgroundImagePath: AppHeroImages.lounge,
          body: AppPageBody(
            footer: failed
                ? AppButton(
                    text: 'Reintentar pago simulado',
                    showChevron: true,
                    onPressed: () {
                      context.read<AgreementsBloc>().add(
                        const SubmitSimulatedPayment(),
                      );
                    },
                  )
                : (completed
                      ? AppButton(
                          text: 'Volver al proyecto',
                          onPressed: () =>
                              Navigator.of(context).popUntil((r) => r.isFirst),
                        )
                      : AppButton(
                          text: 'Confirmar entrega y cerrar obra',
                          showChevron: true,
                          onPressed: () {
                            context.read<AgreementsBloc>().add(
                              const ConfirmWorkCompletedRequested(),
                            );
                          },
                        )),
            children: [
              if (failed)
                AppErrorState(
                  title: 'La transacción de prueba fue rechazada',
                  message: state.errorMessage ??
                      'Puedes reintentar el pago simulado con otro método.',
                )
              else if (agreement != null)
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppBadge(
                        text: 'Pago simulado',
                        variant: AppBadgeVariant.brand,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        completed
                            ? 'Entrega confirmada con ${agreement.contractorName}'
                            : 'Pago simulado registrado para ${agreement.projectTitle}',
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppSpecRow(
                        icon: LucideIcons.hash,
                        label: 'Referencia de prueba',
                        value: agreement.receiptCode ?? 'SIM-RIVET',
                      ),
                      AppSpecRow(
                        icon: LucideIcons.creditCard,
                        label: 'Medio seleccionado',
                        value: agreement.selectedMethod.label,
                      ),
                      AppSpecRow(
                        icon: LucideIcons.coins,
                        label: 'Valor registrado',
                        value:
                            '\$ ${formatCop(agreement.totalAmountCop)} COP',
                      ),
                      AppSpecRow(
                        icon: LucideIcons.checkCheck,
                        label: 'Estado de obra',
                        value: completed
                            ? 'Recibida a satisfacción'
                            : 'En ejecución (Hito 1 activo)',
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
