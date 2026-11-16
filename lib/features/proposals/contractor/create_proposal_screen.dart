import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/widgets/widgets.dart';
import '../../supplier/material_price_tier.dart';
import '../../supplier/materials_catalog_screen.dart';
import '../domain/repositories/proposal_repository.dart';
import 'create_proposal_bloc.dart';

/// Asistente de 3 pasos para crear o editar una propuesta (22:145820).
class CreateProposalScreen extends StatefulWidget {
  const CreateProposalScreen({
    super.key,
    required this.project,
    this.initialProposal,
  });

  final Project project;
  final Proposal? initialProposal;

  static Widget withBloc({
    required Project project,
    Proposal? initialProposal,
  }) {
    return BlocProvider<CreateProposalBloc>(
      create: (context) => CreateProposalBloc.fromRepository(
        context.read<ProposalRepository>(),
        projectId: project.id,
        initialProposal: initialProposal,
      ),
      child: CreateProposalScreen(
        project: project,
        initialProposal: initialProposal,
      ),
    );
  }

  static Route<Proposal?> route({
    required Project project,
    Proposal? initialProposal,
  }) {
    return RivetPageRoute<Proposal?>(
      builder: (_) => withBloc(
        project: project,
        initialProposal: initialProposal,
      ),
    );
  }

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  late final TextEditingController _laborCtrl;
  late final TextEditingController _daysCtrl;
  late final TextEditingController _materialsCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialProposal;
    _laborCtrl = TextEditingController(
      text: initial != null && initial.laborCostCop > 0
          ? initial.laborCostCop.toString()
          : '',
    );
    _daysCtrl = TextEditingController(
      text: (initial?.estimatedDays ?? 3).toString(),
    );
    _materialsCtrl = TextEditingController(
      text: initial != null && initial.materialsCostCop > 0
          ? initial.materialsCostCop.toString()
          : '',
    );
    _notesCtrl = TextEditingController(text: initial?.observations ?? '');
  }

  @override
  void dispose() {
    _laborCtrl.dispose();
    _daysCtrl.dispose();
    _materialsCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  int _parseCop(String value) =>
      int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateProposalBloc, CreateProposalState>(
      listener: (context, state) {
        if (state.isSuccess && state.savedProposal != null) {
          final isDraft = state.savedProposal!.status == ProposalStatus.draft;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  isDraft
                      ? 'Borrador guardado.'
                      : 'Propuesta enviada al cliente.',
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          Navigator.of(context).pop(state.savedProposal);
        }
      },
      builder: (context, state) {
        return RivetScaffold(
          title: 'Crear y enviar\npropuesta',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.planning,
          body: AppPageBody(
            footer: _buildFooter(context, state),
            children: [
              _ProjectBanner(project: widget.project),
              const SizedBox(height: AppSpacing.md),
              _StepHeader(
                currentStep: state.step,
                onStepTap: (step) => context.read<CreateProposalBloc>().add(
                  CreateProposalStepChanged(step),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.isFailure && state.errorMessage != null) ...[
                AppInfoBanner(
                  message: state.errorMessage!,
                  variant: AppInfoBannerVariant.danger,
                  icon: LucideIcons.circleAlert,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (state.step == 0)
                _buildLaborStep(context)
              else if (state.step == 1)
                _buildMaterialsStep(context)
              else
                _buildSummaryStep(state),
              SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLaborStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mano de obra y tiempos', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Mano de obra estimada (COP)',
            hint: 'Ej. 1200000',
            controller: _laborCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.coins,
            onChanged: (v) => context.read<CreateProposalBloc>().add(
              CreateProposalLaborChanged(_parseCop(v)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Duración estimada (días hábiles)',
            hint: 'Ej. 5',
            controller: _daysCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.clock,
            onChanged: (v) => context.read<CreateProposalBloc>().add(
              CreateProposalDaysChanged(int.tryParse(v.trim()) ?? 0),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Alcance y observaciones',
            hint: 'Incluye alistamiento, protección de pisos, manos de pintura...',
            controller: _notesCtrl,
            maxLines: 3,
            prefixIcon: LucideIcons.fileText,
            onChanged: (v) => context.read<CreateProposalBloc>().add(
              CreateProposalObservationsChanged(v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Materiales de Bodega Rivet', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Costo estimado de materiales (COP)',
            hint: 'Ej. 450000',
            controller: _materialsCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.paintRoller,
            onChanged: (v) => context.read<CreateProposalBloc>().add(
              CreateProposalMaterialsChanged(_parseCop(v)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Consultar precios en Bodega Rivet',
            variant: AppButtonVariant.outline,
            icon: LucideIcons.packageSearch,
            onPressed: () => Navigator.of(context).push(
              MaterialsCatalogScreen.route(
                priceTier: MaterialPriceTier.verifiedPro,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(CreateProposalState state) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen de la propuesta', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.sm),
          AppSpecRow(
            icon: LucideIcons.hammer,
            label: 'Mano de obra',
            value: '\$ ${formatCop(state.laborCostCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.paintBucket,
            label: 'Materiales',
            value: '\$ ${formatCop(state.materialsCostCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.clock,
            label: 'Duración estimada',
            value: '${state.estimatedDays} días hábiles',
          ),
          AppSpecRow(
            icon: LucideIcons.coins,
            label: 'Total de la propuesta',
            value: '\$ ${formatCop(state.totalCostCop)} COP',
            showDivider: state.observations.trim().isNotEmpty,
          ),
          if (state.observations.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(state.observations.trim(), style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, CreateProposalState state) {
    if (state.step < 2) {
      return Row(
        children: [
          if (state.step > 0) ...[
            Expanded(
              child: AppButton(
                text: 'Atrás',
                variant: AppButtonVariant.outline,
                onPressed: () => context.read<CreateProposalBloc>().add(
                  CreateProposalStepChanged(state.step - 1),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            flex: 2,
            child: AppButton(
              text: 'Continuar',
              showChevron: true,
              onPressed: () => context.read<CreateProposalBloc>().add(
                CreateProposalStepChanged(state.step + 1),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          text: 'Enviar propuesta',
          isLoading: state.isLoading,
          showChevron: true,
          onPressed: state.isLoading
              ? null
              : () => context.read<CreateProposalBloc>().add(
                  const SaveProposalSubmitted(ProposalStatus.sent),
                ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          text: 'Guardar borrador',
          variant: AppButtonVariant.outline,
          onPressed: state.isLoading
              ? null
              : () => context.read<CreateProposalBloc>().add(
                  const SaveProposalSubmitted(ProposalStatus.draft),
                ),
        ),
      ],
    );
  }
}

class _ProjectBanner extends StatelessWidget {
  const _ProjectBanner({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          const Icon(LucideIcons.house, color: AppColors.brand700, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: AppTypography.bodyStrong),
                Text(
                  '${project.totalAreaM2.toStringAsFixed(1)} m² · ${project.city}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.currentStep, required this.onStepTap});

  final int currentStep;
  final ValueChanged<int> onStepTap;

  static const _labels = ['Mano de obra', 'Materiales', 'Resumen'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _labels.length; i++)
          Expanded(
            child: InkWell(
              onTap: () => onStepTap(i),
              borderRadius: AppSpacing.roundedSm,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: i == currentStep
                            ? const LinearGradient(
                                colors: [
                                  AppColors.brandGradientStart,
                                  AppColors.brandGradientEnd,
                                ],
                              )
                            : null,
                        color: i == currentStep ? null : AppColors.stepIdle,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: AppTypography.captionStrong.copyWith(
                          color: i == currentStep
                              ? AppColors.surface0
                              : AppColors.ink900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _labels[i],
                      style: AppTypography.caption.copyWith(
                        color: i == currentStep
                            ? AppColors.brand700
                            : AppColors.ink700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
