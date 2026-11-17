import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'agreements_module.dart';

/// Alias de compatibilidad hacia [ProjectPaymentScreen].
typedef SimulatedPaymentScreen = ProjectPaymentScreen;

/// Pantalla de pago de anticipo simulado (frames 22-145357, 66-14032, 45-222).
///
/// Nunca almacena número de tarjeta, CVV ni fecha de vencimiento; solo extrae
/// la marca y los últimos 4 dígitos en memoria para el comprobante.
class ProjectPaymentScreen extends StatefulWidget {
  const ProjectPaymentScreen({super.key});

  @override
  State<ProjectPaymentScreen> createState() => _ProjectPaymentScreenState();
}

class _ProjectPaymentScreenState extends State<ProjectPaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _cardBrand = 'Visa';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String? _extractLast4() {
    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return null;
    return digits.substring(digits.length - 4);
  }

  String _inferBrand(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('5')) return 'Mastercard';
    if (digits.startsWith('3')) return 'Amex';
    return 'Visa';
  }

  Future<void> _showReceiptSheet(
    BuildContext context,
    WorkAgreement agreement,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.line300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const AppBadge(
                  text: 'Comprobante de anticipo simulado',
                  variant: AppBadgeVariant.brand,
                  icon: LucideIcons.circleCheck,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Anticipo registrado para ${agreement.projectTitle}',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                AppSpecRow(
                  icon: LucideIcons.hash,
                  label: 'Referencia',
                  value: agreement.receiptCode ?? 'SIM-RIVET',
                ),
                AppSpecRow(
                  icon: LucideIcons.creditCard,
                  label: 'Medio',
                  value: agreement.cardLast4 != null
                      ? '${agreement.cardBrand ?? 'Tarjeta'} •••• ${agreement.cardLast4}'
                      : agreement.selectedMethod.label,
                ),
                AppSpecRow(
                  icon: LucideIcons.coins,
                  label: 'Anticipo (50%)',
                  value: '\$ ${formatCop(agreement.advanceAmountCop)} COP',
                ),
                AppSpecRow(
                  icon: LucideIcons.checkCheck,
                  label: 'Total del acuerdo',
                  value: '\$ ${formatCop(agreement.totalAmountCop)} COP',
                  showDivider: false,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Continuar con la obra',
                  showChevron: true,
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgreementsBloc, AgreementsState>(
      listenWhen: (prev, curr) =>
          curr.hasPaymentResult && !prev.hasPaymentResult,
      listener: (context, state) {
        final agreement = state.agreement;
        if (state.status == AgreementsStatus.success && agreement != null) {
          _showReceiptSheet(context, agreement);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final agreement = state.agreement;
        final isCard = agreement?.selectedMethod == SimulatedPaymentMethod.card;
        return RivetScaffold(
          title: 'Pago de\nanticipo',
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
                            'Confirmar anticipo (\$ ${formatCop(agreement.advanceAmountCop)})',
                        isLoading: state.isProcessingPayment,
                        showChevron: true,
                        onPressed: () {
                          context.read<AgreementsBloc>().add(
                                SubmitSimulatedPayment(
                                  cardBrand: isCard ? _cardBrand : null,
                                  cardLast4: isCard ? _extractLast4() : null,
                                ),
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
              if (state.status == AgreementsStatus.failure &&
                  agreement == null)
                AppErrorState(
                  title: state.isSessionExpired
                      ? 'Sesión vencida'
                      : 'No fue posible cargar el pago',
                  message: state.errorMessage ?? 'Intenta de nuevo.',
                )
              else ...[
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
                            'Operación simulada: no realiza cobros bancarios reales ni almacena datos sensibles de tarjeta.',
                      ),
                      if (agreement != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        AppSpecRow(
                          icon: LucideIcons.wallet,
                          label: 'Anticipo inicial (50%)',
                          value:
                              '\$ ${formatCop(agreement.advanceAmountCop)} COP',
                        ),
                        AppSpecRow(
                          icon: LucideIcons.coins,
                          label: 'Total del acuerdo',
                          value:
                              '\$ ${formatCop(agreement.totalAmountCop)} COP',
                          showDivider: false,
                        ),
                      ],
                    ],
                  ),
                ),
                if (agreement != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medio de pago simulado',
                          style: AppTypography.subheading,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final method in SimulatedPaymentMethod.values)
                          AppListTile(
                            title: method.label,
                            subtitle: 'Registro instantáneo de prueba',
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
                        if (isCard) ...[
                          const Divider(color: AppColors.line300),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(
                            controller: _cardNumberController,
                            label: 'Número de tarjeta de prueba',
                            hint: '4242 4242 4242 4242',
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() => _cardBrand = _inferBrand(val));
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: _expiryController,
                                  label: 'Vencimiento',
                                  hint: '12/28',
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: AppTextField(
                                  controller: _cvvController,
                                  label: 'CVV',
                                  hint: '123',
                                  isPassword: true,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
