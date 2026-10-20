import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme.dart';

/// Caja común de los campos de búsqueda y filtro ("Campo" en 22:144637,
/// 22:144423, 22:144553): blanco, borde 1 `line300`, radio 12, padding
/// horizontal 12, separación 10 e ícono de línea de 19 px.
class _FieldShell extends StatelessWidget {
  const _FieldShell({
    required this.icon,
    required this.height,
    required this.child,
    this.onTap,
  });

  final IconData icon;
  final double height;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedMd,
        side: BorderSide(
          color: AppColors.line300,
          width: AppSpacing.strokeDivider,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedMd,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, size: 19, color: AppColors.brand700),
                const SizedBox(width: 10),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra de búsqueda de 42 px (nodo 22:144652): ícono `search` y texto
/// Roboto 400 13 con placeholder ink500.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.height = 42,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final double height;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.bodyMedium;
    return _FieldShell(
      icon: LucideIcons.search,
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: style.copyWith(color: AppColors.ink900),
        cursorColor: AppColors.brand700,
        decoration: InputDecoration(
          isCollapsed: true,
          // El tema global define padding para campos; aquí va sin él.
          contentPadding: EdgeInsets.zero,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: style,
          hintMaxLines: 1,
        ),
      ),
    );
  }
}

/// Campo de filtro que abre un selector (p. ej. "Ciudad o zona", "Marca"):
/// ícono de línea de 19 px y etiqueta Roboto 400 13. Alto habitual 36–38.
/// Con [value] muestra la selección en ink900 en lugar del placeholder.
class AppFilterField extends StatelessWidget {
  const AppFilterField({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.height = 38,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return Semantics(
      button: true,
      label: hasValue ? '$label: $value' : label,
      excludeSemantics: true,
      child: _FieldShell(
        icon: icon,
        height: height,
        onTap: onTap,
        child: Text(
          hasValue ? value! : label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMedium.copyWith(
            color: hasValue ? AppColors.ink900 : AppColors.ink500,
          ),
        ),
      ),
    );
  }
}

/// Cuadrícula de dos columnas de [AppFilterField] con separación 10 en
/// horizontal y 6 en vertical, como en las pantallas de catálogo.
class AppFilterGrid extends StatelessWidget {
  const AppFilterGrid({super.key, required this.fields, this.rowGap = 6});

  final List<Widget> fields;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < fields.length; i += 2) {
      if (i > 0) rows.add(SizedBox(height: rowGap));
      rows.add(
        Row(
          children: [
            Expanded(child: fields[i]),
            const SizedBox(width: 10),
            Expanded(
              child: i + 1 < fields.length
                  ? fields[i + 1]
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }
}
