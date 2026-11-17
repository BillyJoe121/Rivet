import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'agreements_module.dart';

/// Pantalla de cuenta bancaria del contratista para recibir pagos (frame 66-14323).
///
/// Solo persiste y muestra los últimos 4 dígitos de la cuenta y del documento.
class PayoutAccountScreen extends StatefulWidget {
  const PayoutAccountScreen({super.key});

  static Widget withBloc() {
    return BlocProvider<PayoutAccountBloc>(
      create: (context) =>
          PayoutAccountBloc.fromRepository(context.read<AgreementRepository>())
            ..add(const LoadPayoutAccountRequested()),
      child: const PayoutAccountScreen(),
    );
  }

  static Route<void> route() {
    return RivetPageRoute<void>(builder: (_) => withBloc());
  }

  @override
  State<PayoutAccountScreen> createState() => _PayoutAccountScreenState();
}

class _PayoutAccountScreenState extends State<PayoutAccountScreen> {
  final _bankController = TextEditingController(text: 'Bancolombia');
  final _holderController = TextEditingController();
  final _accountController = TextEditingController();
  final _documentController = TextEditingController();
  bool _prefilled = false;

  @override
  void dispose() {
    _bankController.dispose();
    _holderController.dispose();
    _accountController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  void _prefillFromAccount(PayoutAccount? account) {
    if (_prefilled || account == null) return;
    _prefilled = true;
    _bankController.text = account.bankName;
    _holderController.text = account.holderName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayoutAccountBloc, PayoutAccountState>(
      listener: (context, state) {
        if (state.savedSuccessfully) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Cuenta de cobro guardada con datos enmascarados.'),
              ),
            );
        } else if (state.status == PayoutAccountStatus.failure &&
            state.errorMessage != null &&
            state.account != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        _prefillFromAccount(state.account);
        final account = state.account;

        return RivetScaffold(
          title: 'Cuenta para\nrecibir pagos',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.trust,
          body: AppPageBody(
            footer: AppButton(
              text: account == null
                  ? 'Guardar cuenta de cobro'
                  : 'Actualizar cuenta de cobro',
              isLoading: state.isSaving,
              showChevron: true,
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<PayoutAccountBloc>().add(
                            SavePayoutAccountRequested(
                              bankName: _bankController.text,
                              accountType: state.selectedAccountType,
                              accountNumber: _accountController.text,
                              holderName: _holderController.text,
                              documentNumber: _documentController.text,
                            ),
                          );
                    },
            ),
            children: [
              if (state.isLoading && account == null)
                const AppLoadingState(label: 'Consultando cuenta de cobro')
              else if (state.status == PayoutAccountStatus.failure &&
                  account == null &&
                  state.isSessionExpired)
                AppErrorState(
                  title: 'Sesión vencida',
                  message: state.errorMessage ??
                      'Inicia sesión nuevamente para gestionar tu cuenta.',
                )
              else if (state.status == PayoutAccountStatus.failure &&
                  account == null &&
                  state.isPermissionDenied)
                AppErrorState(
                  title: 'Permiso insuficiente',
                  message: state.errorMessage ??
                      'Solo el contratista titular puede gestionar esta cuenta.',
                )
              else ...[
                if (account != null) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBadge(
                          text: account.isVerified
                              ? 'Cuenta verificada'
                              : 'Pendiente de verificación',
                          variant: account.isVerified
                              ? AppBadgeVariant.brand
                              : AppBadgeVariant.warning,
                          icon: account.isVerified
                              ? LucideIcons.circleCheck
                              : LucideIcons.clock,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppSpecRow(
                          icon: LucideIcons.landmark,
                          label: 'Banco',
                          value: account.bankName,
                        ),
                        AppSpecRow(
                          icon: LucideIcons.creditCard,
                          label: 'Cuenta (${account.accountType})',
                          value: account.maskedAccountNumber,
                        ),
                        AppSpecRow(
                          icon: LucideIcons.userCheck,
                          label: 'Titular',
                          value: account.holderName,
                        ),
                        AppSpecRow(
                          icon: LucideIcons.idCard,
                          label: 'Documento',
                          value: account.maskedDocumentNumber,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ] else ...[
                  const AppInfoBanner(
                    message:
                        'Registra tu cuenta bancaria para recibir los desembolsos de tus obras. Solo guardamos los últimos 4 dígitos.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account == null
                            ? 'Datos de la cuenta'
                            : 'Actualizar datos bancarios',
                        style: AppTypography.subheading,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _bankController,
                        label: 'Entidad bancaria',
                        hint: 'Bancolombia, Davivienda, Nequi...',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppSegmentedControl<String>(
                        items: const {
                          'ahorros': 'Ahorros',
                          'corriente': 'Corriente',
                        },
                        selected: state.selectedAccountType,
                        onChanged: (val) => context
                            .read<PayoutAccountBloc>()
                            .add(PayoutAccountTypeChanged(val)),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _holderController,
                        label: 'Nombre del titular',
                        hint: 'Como aparece en el banco',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _accountController,
                        label: 'Número de cuenta',
                        hint: 'Ingresa al menos 6 dígitos',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _documentController,
                        label: 'Documento de identidad',
                        hint: 'Cédula o NIT',
                        keyboardType: TextInputType.number,
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
