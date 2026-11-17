import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'agreements_module.dart';

/// Resumen de pago recibido y liberación simulada (frame 66-14883).
class PaymentReceivedScreen extends StatelessWidget {
  const PaymentReceivedScreen({
    super.key,
    required this.agreementId,
  });

  final String agreementId;

  static Widget withBloc({required String agreementId}) {
    return BlocProvider<ClosureBloc>(
      create: (context) =>
          ClosureBloc.fromRepository(context.read<AgreementRepository>())
            ..add(LoadClosureRequested(agreementId)),
      child: PaymentReceivedScreen(agreementId: agreementId),
    );
  }

  static Route<void> route({required String agreementId}) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(agreementId: agreementId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClosureBloc, ClosureState>(
      listener: (context, state) {
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;
        final payout = state.payoutAccount;
        final payments = state.payments;

        return RivetScaffold(
          title: 'Pago\nrecibido',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.trust,
          body: AppPageBody(
            footer: AppButton(
              text: 'Volver al inicio',
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            ),
            children: [
              if (state.isLoading && agreement == null)
                const AppLoadingState(label: 'Consultando pagos del acuerdo')
              else if (agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : (state.isPermissionDenied
                            ? 'Permiso insuficiente'
                            : 'No pudimos cargar los pagos'),
                  message: state.errorMessage ?? 'Intenta nuevamente.',
                )
              else ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppBadge(
                        text: 'Pago simulado · Entorno de prueba',
                        variant: AppBadgeVariant.brand,
                        icon: LucideIcons.circleCheck,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        agreement.projectTitle,
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppSpecRow(
                        icon: LucideIcons.hammer,
                        label: 'Mano de obra',
                        value: '\$ ${formatCop(agreement.laborAmountCop)} COP',
                      ),
                      AppSpecRow(
                        icon: LucideIcons.paintBucket,
                        label: 'Materiales',
                        value:
                            '\$ ${formatCop(agreement.materialsAmountCop)} COP',
                      ),
                      AppSpecRow(
                        icon: LucideIcons.coins,
                        label: 'Total del acuerdo',
                        value: '\$ ${formatCop(agreement.totalAmountCop)} COP',
                        showDivider: payout != null,
                      ),
                      if (payout != null)
                        AppSpecRow(
                          icon: LucideIcons.landmark,
                          label: 'Cuenta destino',
                          value: '${payout.bankName} ${payout.maskedAccountNumber}',
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
                      AppSectionHeader(
                        title: 'Movimientos registrados',
                        count: payments.length,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (payments.isEmpty)
                        const AppEmptyState(
                          title: 'Sin movimientos registrados',
                          message:
                              'Cuando se registre un anticipo o saldo, aparecerá aquí.',
                          icon: LucideIcons.wallet,
                        )
                      else
                        for (final p in payments)
                          AppListTile(
                            title:
                                '${p.kind == 'advance' ? 'Anticipo' : 'Saldo'} · \$ ${formatCop(p.amountCop)} COP',
                            subtitle: 'Estado: ${p.status.name}',
                            leadingIcon: LucideIcons.creditCard,
                            showChevron: false,
                            trailing: p.status == SimulatedPaymentStatus.held ||
                                    p.status == SimulatedPaymentStatus.approved
                                ? TextButton(
                                    onPressed: state.isSubmitting
                                        ? null
                                        : () => context
                                              .read<ClosureBloc>()
                                              .add(ReleasePaymentRequested(p.id)),
                                    child: const Text('Liberar'),
                                  )
                                : null,
                          ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
