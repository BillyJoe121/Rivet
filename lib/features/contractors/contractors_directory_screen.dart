import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'contractors_module.dart';
import 'contractors_screens.dart';

/// Directorio de contratistas con buscador fijo y hoja inferior de filtros (P-019).
class ContractorsDirectoryScreen extends StatelessWidget {
  const ContractorsDirectoryScreen({super.key, this.contractorsBloc});

  final ContractorsBloc? contractorsBloc;

  @override
  Widget build(BuildContext context) {
    if (contractorsBloc != null) {
      return BlocProvider<ContractorsBloc>.value(
        value: contractorsBloc!,
        child: const _ContractorsDirectoryView(),
      );
    }

    try {
      context.read<ContractorsBloc>();
      return const _ContractorsDirectoryView();
    } catch (_) {
      return BlocProvider<ContractorsBloc>(
        create: (_) => ContractorsBloc(
          ContractorsService.instance.getContractorsUseCase,
          ContractorsService.instance.requestContractorVisitUseCase,
        )..add(const LoadContractors()),
        child: const _ContractorsDirectoryView(),
      );
    }
  }
}

class _ContractorsDirectoryView extends StatefulWidget {
  const _ContractorsDirectoryView();

  @override
  State<_ContractorsDirectoryView> createState() =>
      _ContractorsDirectoryViewState();
}

class _ContractorsDirectoryViewState extends State<_ContractorsDirectoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _activeFilterCount(ContractorsState state) {
    var count = 0;
    if (state.selectedTrade != null) count++;
    if (state.selectedZone != null) count++;
    if (state.minRating > 0) count++;
    if (state.onlyVerified) count++;
    return count;
  }

  void _clearAllFilters(BuildContext context) {
    _searchController.clear();
    context.read<ContractorsBloc>()
      ..add(const UpdateContractorSearch(''))
      ..add(const UpdateContractorTradeFilter(null))
      ..add(const UpdateContractorZoneFilter(null))
      ..add(const UpdateContractorRatingFilter(0))
      ..add(const ToggleContractorVerifiedOnly(false));
  }

  Future<void> _openFilterSheet(
    BuildContext context,
    ContractorsState state,
  ) async {
    final bloc = context.read<ContractorsBloc>();
    final result = await showAppBottomSheet<_ContractorFiltersResult>(
      context,
      builder: (_) => _ContractorFilterSheet(
        initialTrade: state.selectedTrade,
        initialZone: state.selectedZone,
        initialMinRating: state.minRating,
        initialOnlyVerified: state.onlyVerified,
      ),
    );
    if (result != null) {
      bloc
        ..add(UpdateContractorTradeFilter(result.trade))
        ..add(UpdateContractorZoneFilter(result.zone))
        ..add(UpdateContractorRatingFilter(result.minRating))
        ..add(ToggleContractorVerifiedOnly(result.onlyVerified));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractorsBloc, ContractorsState>(
      builder: (context, state) {
        final contractors = state.filteredContractors;
        final activeFilters = _activeFilterCount(state);

        return RivetScaffold(
          title: 'Contratistas',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.paintRoller,
          body: AppPageBody(
            fixedHeader: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Buscar por nombre, especialidad o barrio',
                  onChanged: (value) {
                    context.read<ContractorsBloc>().add(
                      UpdateContractorSearch(value),
                    );
                  },
                ),
                const SizedBox(height: 6),
                AppFilterField(
                  icon: LucideIcons.slidersHorizontal,
                  label: 'Filtros',
                  value: activeFilters == 0
                      ? null
                      : activeFilters == 1
                      ? '1 filtro activo'
                      : '$activeFilters filtros activos',
                  onTap: () => _openFilterSheet(context, state),
                ),
                const SizedBox(height: AppSpacing.md),
                AppSectionHeader(
                  title: 'Profesionales disponibles',
                  count: contractors.length,
                ),
              ],
            ),
            children: [
              if (state.isLoading && state.contractors.isEmpty)
                const AppLoadingState(label: 'Cargando contratistas')
              else if (state.status == ContractorsStatus.failure &&
                  state.contractors.isEmpty)
                AppErrorState(
                  message:
                      state.errorMessage ?? 'No pudimos cargar el directorio.',
                  onRetry: () => context.read<ContractorsBloc>().add(
                    const LoadContractors(),
                  ),
                )
              else if (contractors.isEmpty)
                AppEmptyState(
                  title: 'Sin coincidencias en este filtro',
                  message:
                      'Prueba con otra especialidad o limpia los filtros activos para ver más contratistas en Cali.',
                  icon: LucideIcons.userCheck,
                  actionLabel: 'Limpiar filtros',
                  onAction: () => _clearAllFilters(context),
                )
              else
                for (var i = 0; i < contractors.length; i++) ...[
                  _ContractorDirectoryCard(
                    contractor: contractors[i],
                    onTap: () {
                      final bloc = context.read<ContractorsBloc>();
                      AppNavigator.push(
                        context,
                        BlocProvider<ContractorsBloc>.value(
                          value: bloc,
                          child: ContractorProfileScreen(
                            contractor: contractors[i],
                          ),
                        ),
                      );
                    },
                  ),
                  if (i < contractors.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _ContractorFiltersResult {
  const _ContractorFiltersResult({
    this.trade,
    this.zone,
    this.minRating = 0,
    this.onlyVerified = false,
  });

  final String? trade;
  final String? zone;
  final double minRating;
  final bool onlyVerified;
}

class _ContractorFilterSheet extends StatefulWidget {
  const _ContractorFilterSheet({
    this.initialTrade,
    this.initialZone,
    this.initialMinRating = 0,
    this.initialOnlyVerified = false,
  });

  final String? initialTrade;
  final String? initialZone;
  final double initialMinRating;
  final bool initialOnlyVerified;

  @override
  State<_ContractorFilterSheet> createState() => _ContractorFilterSheetState();
}

class _ContractorFilterSheetState extends State<_ContractorFilterSheet> {
  static const List<String> _trades = [
    'Pintura',
    'Estuco',
    'Drywall',
    'Resanes',
    'Impermeabilización',
  ];

  static const List<String> _zones = ['Sur', 'Norte', 'Oeste', 'Centro'];

  late String? _trade = widget.initialTrade;
  late String? _zone = widget.initialZone;
  late double _minRating = widget.initialMinRating;
  late bool _onlyVerified = widget.initialOnlyVerified;

  void _clear() => setState(() {
    _trade = null;
    _zone = null;
    _minRating = 0;
    _onlyVerified = false;
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filtros', style: AppTypography.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _group('Especialidad', [
                    for (final t in _trades)
                      _chip(
                        t,
                        _trade == t,
                        () => _trade = _trade == t ? null : t,
                      ),
                  ]),
                  _group('Zona en Cali', [
                    for (final z in _zones)
                      _chip(
                        'Zona $z',
                        _zone == z,
                        () => _zone = _zone == z ? null : z,
                      ),
                  ]),
                  _group('Calificación mínima', [
                    _chip(
                      '4.8+ estrellas',
                      _minRating >= 4.8,
                      () => _minRating = _minRating >= 4.8 ? 0 : 4.8,
                    ),
                    _chip(
                      '4.5+ estrellas',
                      _minRating == 4.5,
                      () => _minRating = _minRating == 4.5 ? 0 : 4.5,
                    ),
                  ]),
                  _group('Respaldo', [
                    _chip(
                      'Solo perfiles verificados',
                      _onlyVerified,
                      () => _onlyVerified = !_onlyVerified,
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Limpiar',
                  variant: AppButtonVariant.outline,
                  onPressed: _clear,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  text: 'Aplicar',
                  onPressed: () => Navigator.of(context).pop(
                    _ContractorFiltersResult(
                      trade: _trade,
                      zone: _zone,
                      minRating: _minRating,
                      onlyVerified: _onlyVerified,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _group(String title, List<Widget> chips) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.labelStrong),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: chips,
        ),
      ],
    ),
  );

  Widget _chip(String label, bool selected, VoidCallback change) =>
      AppFilterChip(
        label: label,
        selected: selected,
        onTap: () => setState(change),
      );
}

class _ContractorDirectoryCard extends StatelessWidget {
  const _ContractorDirectoryCard({
    required this.contractor,
    required this.onTap,
  });

  final Contractor contractor;
  final VoidCallback onTap;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'C';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.paper100,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(initials: _initials(contractor.name), size: 44),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.subheading,
                          ),
                        ),
                        if (contractor.isVerified) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            LucideIcons.badgeCheck,
                            size: 16,
                            color: AppColors.brand700,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${contractor.trade} · ${contractor.zone}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                text: '${contractor.rating.toStringAsFixed(1)} ★',
                variant: AppBadgeVariant.brand,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            contractor.bio,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppBadge(
                text: contractor.trade,
                variant: AppBadgeVariant.neutral,
                compact: true,
              ),
              AppBadge(
                text: '${contractor.completedJobs} obras',
                variant: AppBadgeVariant.success,
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
