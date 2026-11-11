import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../messaging/messaging_screens.dart';
import '../supplier/material_price_tier.dart';
import 'contractors_module.dart';

/// Perfil público de contratista con jerarquía clara de decisión (P-020).
class ContractorProfileScreen extends StatelessWidget {
  const ContractorProfileScreen({
    super.key,
    required this.contractor,
    this.projectId,
  });

  final Contractor contractor;
  final String? projectId;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'C';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  static const List<(String, String)> _portfolioSamples = [
    ('Apartamento en Ciudad Jardín', 'assets/hero/hero_living_room.jpg'),
    ('Acabado mineral en Pance', 'assets/hero/hero_greenery.jpg'),
    ('Renovación de estudio en El Peñón', 'assets/hero/hero_lounge.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Perfil del\ncontratista',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.paintRoller,
      body: AppPageBody(
        footer: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                text: 'Solicitar visita técnica',
                showChevron: true,
                onPressed: () => AppNavigator.push(
                  context,
                  VisitRequestScreen(
                    contractor: contractor,
                    projectId: projectId ?? 'proj-101',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                text: 'Escribir mensaje',
                variant: AppButtonVariant.outline,
                icon: LucideIcons.messageSquare,
                onPressed: () => AppNavigator.push(
                  context,
                  ProjectChatScreen(
                    conversationId: 'conv-001',
                    contractorName: contractor.name,
                    projectTitle: 'Acabados y pintura residencial',
                  ),
                ),
              ),
            ],
          ),
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          // 1. Foco principal: Identidad y métricas clave de confianza
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppAvatar(initials: _initials(contractor.name), size: 56),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  contractor.name,
                                  style: AppTypography.sectionTitle,
                                ),
                              ),
                              if (contractor.isVerified) ...[
                                const SizedBox(width: AppSpacing.xs),
                                const Icon(
                                  LucideIcons.badgeCheck,
                                  size: 18,
                                  color: AppColors.brand700,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            contractor.trade,
                            style: AppTypography.bodyStrong.copyWith(
                              color: AppColors.brand700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(contractor.zone, style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.paper100,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MetricColumn(
                        value: '${contractor.rating.toStringAsFixed(1)} ★',
                        label: '${contractor.reviewCount} reseñas',
                      ),
                      Container(width: 1, height: 28, color: AppColors.line300),
                      _MetricColumn(
                        value: '${contractor.completedJobs}',
                        label: 'Obras entregadas',
                      ),
                      Container(width: 1, height: 28, color: AppColors.line300),
                      _MetricColumn(
                        value: contractor.isVerified ? 'Verificado' : 'Activo',
                        label: 'Estado en Cali',
                      ),
                    ],
                  ),
                ),
                if (contractor.bio.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(contractor.bio, style: AppTypography.bodyMedium),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // 2. Evidencia visual: Portafolio de trabajos recientes
          const AppSectionHeader(title: 'Trabajos recientes', count: 3),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 152,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _portfolioSamples.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final (caption, asset) = _portfolioSamples[index];
                return SizedBox(
                  width: 215,
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.radiusLg),
                          ),
                          child: Image.asset(
                            asset,
                            height: 102,
                            width: 215,
                            cacheWidth: 430,
                            cacheHeight: 204,
                            gaplessPlayback: true,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              height: 102,
                              color: AppColors.brandLight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Text(
                            caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelStrong,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subheading.copyWith(color: AppColors.brand700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

/// Solicitud y confirmación de visita técnica con pago simulado (P-021, P-022).
class VisitRequestScreen extends StatefulWidget {
  const VisitRequestScreen({
    super.key,
    required this.contractor,
    this.projectId = 'proj-101',
    this.contractorsBloc,
  });

  final Contractor contractor;
  final String projectId;
  final ContractorsBloc? contractorsBloc;

  @override
  State<VisitRequestScreen> createState() => _VisitRequestScreenState();
}

class _VisitRequestScreenState extends State<VisitRequestScreen> {
  final TextEditingController _addressController = TextEditingController(
    text: 'Cra. 102 #14-80, Ciudad Jardín, Cali',
  );
  final TextEditingController _dateController = TextEditingController(
    text: 'Sábado 16 de mayo',
  );
  final TextEditingController _notesController = TextEditingController(
    text: 'Revisar humedad en esquina inferior y confirmar metraje de sala.',
  );

  String _selectedSlot = 'Mañana (9:00 a. m. - 12:00 m.)';
  static const int _visitFeeCop = 45000;

  static const List<String> _timeSlots = [
    'Mañana (9:00 a. m. - 12:00 m.)',
    'Tarde (2:00 p. m. - 5:00 p. m.)',
    'Sábado (9:00 a. m. - 1:00 p. m.)',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.contractorsBloc ?? _resolveBloc(context);
    return BlocProvider<ContractorsBloc>.value(
      value: bloc,
      child: BlocConsumer<ContractorsBloc, ContractorsState>(
        listener: (context, state) {
          if (state.status == ContractorsStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  duration: const Duration(seconds: 5),
                ),
              );
          }
        },
        builder: (context, state) {
          final visit = state.lastVisitRequest;
          final isConfirmed =
              visit != null &&
              visit.contractorId == widget.contractor.id &&
              state.status == ContractorsStatus.success;

          return RivetScaffold(
            title: isConfirmed
                ? 'Visita\nprogramada'
                : 'Solicitar\nvisita',
            showBackButton: true,
            backgroundImagePath: AppHeroImages.paintRoller,
            body: AppPageBody(
              footer: isConfirmed
                  ? AppButton(
                      text: 'Volver al perfil del contratista',
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : AppButton(
                      text:
                          'Confirmar visita · Pago simulado (\$ ${formatCop(_visitFeeCop)})',
                      isLoading: state.isSubmittingVisit,
                      showChevron: true,
                      onPressed: () {
                        context.read<ContractorsBloc>().add(
                          SubmitVisitRequest(
                            contractorId: widget.contractor.id,
                            contractorName: widget.contractor.name,
                            projectId: widget.projectId,
                            address: _addressController.text,
                            preferredDate: _dateController.text,
                            timeSlot: _selectedSlot,
                            notes: _notesController.text,
                            feeCop: _visitFeeCop,
                          ),
                        );
                      },
                    ),
              children: [
                if (isConfirmed)
                  _VisitConfirmedCard(visit: visit)
                else ...[
                  const AppInfoBanner(
                    message:
                        'Pago simulado de prueba: el valor de la visita técnica (\$ 45.000 COP) se abona al presupuesto si contratas la obra con este profesional.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.contractor.name,
                          style: AppTypography.subheading,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.contractor.trade} · ${widget.contractor.zone}',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Dirección del inmueble en Cali',
                          controller: _addressController,
                          prefixIcon: LucideIcons.mapPin,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Fecha preferida',
                          controller: _dateController,
                          prefixIcon: LucideIcons.calendar,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Franja horaria',
                          style: AppTypography.labelStrong,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppFilterChips(
                          labels: _timeSlots,
                          selectedIndex: _timeSlots.indexOf(_selectedSlot),
                          onSelected: (index) {
                            setState(() => _selectedSlot = _timeSlots[index]);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Notas para la inspección',
                          controller: _notesController,
                          maxLines: 3,
                          prefixIcon: LucideIcons.clipboardList,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  ContractorsBloc _resolveBloc(BuildContext context) {
    try {
      return context.read<ContractorsBloc>();
    } catch (_) {
      final repository = context.read<ContractorRepository>();
      return ContractorsBloc(
        GetContractorsUseCase(repository),
        RequestContractorVisitUseCase(repository),
      );
    }
  }
}

class _VisitConfirmedCard extends StatelessWidget {
  const _VisitConfirmedCard({required this.visit});

  final VisitRequest visit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.circleCheck,
                color: AppColors.brand700,
                size: 24,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Solicitud enviada con pago simulado',
                  style: TextStyle(
                    fontFamily: AppTypography.serif,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSpecRow(
            icon: LucideIcons.userCheck,
            label: 'Profesional',
            value: visit.contractorName,
          ),
          AppSpecRow(
            icon: LucideIcons.mapPin,
            label: 'Dirección',
            value: visit.address,
          ),
          AppSpecRow(
            icon: LucideIcons.calendar,
            label: 'Fecha y franja',
            value: '${visit.preferredDate} · ${visit.timeSlot}',
          ),
          AppSpecRow(
            icon: LucideIcons.wallet,
            label: 'Modalidad',
            value: 'Pago simulado · \$ ${formatCop(visit.feeCop)} COP',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
