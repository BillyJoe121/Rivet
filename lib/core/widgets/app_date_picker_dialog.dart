import 'package:flutter/material.dart';
// Trazo 2 a 16 px en el diseño equivale al peso 600 de Lucide.
import 'package:lucide_icons_flutter/lucide_icons_600.dart';

import '../theme/theme.dart';
import 'app_modal.dart';

// Colores del día no disponible; no existen como tokens.
const Color _disabledFill = Color(0xFFE3E6E6);
const Color _disabledText = Color(0xFF7B8588);

const List<String> _monthNames = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', //
  'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];
const List<String> _weekdayNames = [
  'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom', //
];

const double _cellSize = 36;
const double _columnGap = 4;
const double _rowGap = 8;

/// Modal "Elegir fecha" (nodo 2004:167): mes con flechas, encabezado de días
/// (semana de lunes a domingo) y cuadrícula de días de 36 px.
class AppDatePickerDialog extends StatefulWidget {
  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.title = 'Elegir fecha',
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
  });

  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Permite marcar días no disponibles (p. ej. fines de semana).
  final bool Function(DateTime day)? selectableDayPredicate;
  final String title;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  late DateTime _month = DateTime(
    widget.initialDate.year,
    widget.initialDate.month,
  );
  late DateTime? _selected = _isSelectable(widget.initialDate)
      ? DateUtils.dateOnly(widget.initialDate)
      : null;

  bool _isSelectable(DateTime day) {
    final date = DateUtils.dateOnly(day);
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null && date.isBefore(DateUtils.dateOnly(first))) {
      return false;
    }
    if (last != null && date.isAfter(DateUtils.dateOnly(last))) return false;
    return widget.selectableDayPredicate?.call(date) ?? true;
  }

  bool get _canGoBack {
    final first = widget.firstDate;
    return first == null || DateTime(first.year, first.month).isBefore(_month);
  }

  bool get _canGoForward {
    final last = widget.lastDate;
    return last == null || DateTime(last.year, last.month).isAfter(_month);
  }

  void _shiftMonth(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    return AppModal(
      children: [
        AppModalTitle(widget.title),
        _buildCalendar(),
        AppModalActions(
          confirmLabel: widget.confirmLabel,
          cancelLabel: widget.cancelLabel,
          onConfirm: _selected == null
              ? null
              : () => Navigator.of(context).pop(_selected),
          onCancel: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    // La cuadrícula empieza el lunes de la semana del día 1.
    final firstOfMonth = DateTime(_month.year, _month.month);
    final start = firstOfMonth.subtract(
      Duration(days: firstOfMonth.weekday - DateTime.monday),
    );
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final weeks = ((firstOfMonth.weekday - 1 + daysInMonth) / 7).ceil();

    final rows = <Widget>[
      SizedBox(
        height: 28,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${_monthNames[_month.month - 1]} ${_month.year}',
                style: AppTypography.titleSmall.copyWith(height: 16.4 / 14),
              ),
            ),
            _MonthArrow(
              icon: LucideIcons600.chevronLeft,
              tooltip: 'Mes anterior',
              onTap: _canGoBack ? () => _shiftMonth(-1) : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            _MonthArrow(
              icon: LucideIcons600.chevronRight,
              tooltip: 'Mes siguiente',
              onTap: _canGoForward ? () => _shiftMonth(1) : null,
            ),
          ],
        ),
      ),
      _gridRow([
        for (final name in _weekdayNames)
          SizedBox(
            height: 24,
            child: Center(
              child: Text(
                name,
                style: AppTypography.captionStrong.copyWith(
                  color: AppColors.ink500,
                  height: 12.9 / 11,
                ),
              ),
            ),
          ),
      ]),
    ];

    for (var w = 0; w < weeks; w++) {
      rows.add(
        _gridRow([
          for (var d = 0; d < 7; d++)
            _buildDay(DateTime(start.year, start.month, start.day + w * 7 + d)),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: _rowGap),
          rows[i],
        ],
      ],
    );
  }

  Widget _gridRow(List<Widget> cells) {
    return Row(
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          if (i > 0) const SizedBox(width: _columnGap),
          SizedBox(width: _cellSize, child: cells[i]),
        ],
      ],
    );
  }

  Widget _buildDay(DateTime day) {
    final inMonth = day.month == _month.month;
    final enabled = inMonth && _isSelectable(day);
    final selected = _selected != null && DateUtils.isSameDay(day, _selected);
    final Color fill;
    final Color textColor;
    if (selected) {
      fill = AppColors.brand700;
      textColor = AppColors.surface0;
    } else if (enabled) {
      fill = AppColors.surface0;
      textColor = AppColors.ink900;
    } else {
      fill = _disabledFill;
      textColor = _disabledText;
    }
    return _DayCell(
      day: day.day,
      fill: fill,
      textColor: textColor,
      selected: selected,
      onTap: enabled ? () => setState(() => _selected = day) : null,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.fill,
    required this.textColor,
    required this.selected,
    this.onTap,
  });

  final int day;
  final Color fill;
  final Color textColor;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: selected,
      enabled: onTap != null,
      child: Material(
        color: fill,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedSm,
          side: BorderSide(
            color: AppColors.line300,
            width: AppSpacing.strokeCard,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedSm,
          child: SizedBox.square(
            dimension: _cellSize,
            child: Center(
              child: Text(
                '$day',
                style: AppTypography.labelStrong.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.paper100,
        shape: const CircleBorder(
          side: BorderSide(
            color: AppColors.line300,
            width: AppSpacing.strokeCard,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 28,
            child: Icon(
              icon,
              size: 16,
              color: onTap == null ? AppColors.ink300 : AppColors.brand700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Muestra [AppDatePickerDialog] y devuelve la fecha confirmada o `null`.
Future<DateTime?> showAppDatePickerDialog(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  bool Function(DateTime day)? selectableDayPredicate,
  String title = 'Elegir fecha',
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
}) {
  return showAppModal<DateTime>(
    context,
    builder: (_) => AppDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: selectableDayPredicate,
      title: title,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}
