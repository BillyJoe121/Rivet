import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import '../supplier/material_price_tier.dart';
import 'contractors_module.dart';

/// Solicitud y confirmación de visita técnica con pago simulado (P-021, P-022).
class VisitRequestScreen extends StatefulWidget {
  const VisitRequestScreen({
    super.key,
    required this.contractor,
    this.projectId = '',
  });

  final Contractor contractor;
  final String projectId;

  static Widget withBloc({
    required Contractor contractor,
    String projectId = '',
  }) {
    return BlocProvider<ContractorsBloc>(
      create: (_) => sl<ContractorsBloc>(),
      child: VisitRequestScreen(
        contractor: contractor,
        projectId: projectId,
      ),
    );
  }

  static Route<void> route({
    required Contractor contractor,
    String projectId = '',
  }) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(contractor: contractor, projectId: projectId),
    );
  }

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
    return BlocConsumer<ContractorsBloc, ContractorsState>(
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
          title: isConfirmed ? 'Visita\nprogramada' : 'Solicitar\nvisita',
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
    );
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
