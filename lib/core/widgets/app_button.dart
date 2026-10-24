import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary, outline, subtle, ghost, danger }
enum AppButtonSize { sm, md, lg }

/// Botón píldora medido del Figma "Rivet v2".
///
/// - `sm`: acción compacta dentro de tarjetas (alto 32, Roboto 600 12/14.4,
///   padding horizontal 14, chevron 6×11).
/// - `md`: acción de pie de pantalla (alto 48, Roboto 600 14/16.8,
///   padding horizontal 16).
/// - `lg`: botón principal de Login/Registro (alto 56, radio 32, gradiente de
///   tres paradas, sombra de marca y flecha en círculo blanco al 15 %).
///
/// La etiqueta ocupa el espacio libre y se centra; el chevron va a la
/// derecha. El chevron se dibuja con las medidas exactas del diseño cuando
/// [showChevron] es verdadero o [trailingIcon] es un chevron derecho.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.showChevron = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;

  /// Muestra el chevron de avance (6×11, trazo 1.7) a la derecha.
  final bool showChevron;

  // Gradiente del botón grande de Login/Registro (#278D82 → #08655D →
  // #003D38). En un botón tan ancho el avance es vertical, como el de marca.
  // Sin token propio en el tema.
  static const LinearGradient _heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.46, 1],
    colors: [Color(0xFF278D82), Color(0xFF08655D), AppColors.brandGradientEnd],
  );

  bool get _isDisabled => onPressed == null && !isLoading;

  bool get _isChevron =>
      showChevron ||
      trailingIcon == Icons.chevron_right ||
      trailingIcon == Icons.chevron_right_rounded ||
      trailingIcon == LucideIcons.chevronRight;

  @override
  Widget build(BuildContext context) {
    final spec = _ButtonSpec.of(size);
    final fg = _foregroundColor();
    final radius = BorderRadius.circular(spec.radius);
    final isHero = size == AppButtonSize.lg && variant == AppButtonVariant.primary;

    final label = Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: spec.textStyle.copyWith(color: fg),
    );

    Widget? leading;
    if (isLoading) {
      leading = SizedBox(
        width: spec.iconSize,
        height: spec.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else if (icon != null) {
      leading = Icon(icon, size: spec.iconSize, color: _iconColor(fg));
    }

    Widget? trailing;
    if (!isLoading) {
      if (isHero && (_isChevron || trailingIcon != null)) {
        trailing = _HeroArrow(icon: _isChevron ? null : trailingIcon);
      } else if (_isChevron) {
        trailing = _Chevron(color: fg);
      } else if (trailingIcon != null) {
        trailing = Icon(trailingIcon, size: spec.iconSize, color: fg);
      }
    }

    final children = <Widget>[
      // En el botón grande un espaciador equilibra la flecha de la derecha.
      if (isHero && trailing != null && leading == null)
        const SizedBox(width: 32),
      if (leading != null) ...[leading, SizedBox(width: spec.iconGap)],
      // Sin ancho completo el botón puede vivir en filas sin límite de ancho,
      // así que la etiqueta no usa flex.
      if (isFullWidth) Expanded(child: label) else label,
      if (trailing != null) ...[SizedBox(width: spec.gap), trailing],
    ];

    final decoration = BoxDecoration(
      color: _backgroundColor(),
      gradient: _isDisabled || variant != AppButtonVariant.primary
          ? null
          : (isHero ? _heroGradient : AppColors.brandGradient),
      borderRadius: radius,
    );
    final border = _border();

    // El trazo es interior (como en Figma) y se pinta encima sin desplazar
    // la etiqueta.
    Widget button = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: isHero && !_isDisabled ? AppSpacing.shadowBrand : null,
      ),
      foregroundDecoration: border == null
          ? null
          : BoxDecoration(borderRadius: radius, border: border),
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: spec.height,
          decoration: decoration,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: radius,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spec.paddingH),
              child: Row(
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Color? _backgroundColor() {
    if (_isDisabled) return AppColors.line300;
    return switch (variant) {
      AppButtonVariant.primary => null, // Usa el gradiente de marca
      AppButtonVariant.secondary => AppColors.surface0,
      AppButtonVariant.outline => AppColors.paper100,
      AppButtonVariant.subtle => AppColors.brandLight,
      AppButtonVariant.ghost => Colors.transparent,
      AppButtonVariant.danger => AppColors.danger700,
    };
  }

  Color _foregroundColor() {
    if (_isDisabled) return AppColors.ink500;
    return switch (variant) {
      AppButtonVariant.primary => AppColors.surface0,
      AppButtonVariant.secondary => AppColors.ink900,
      AppButtonVariant.outline => AppColors.brand700,
      AppButtonVariant.subtle => AppColors.brand700,
      AppButtonVariant.ghost => AppColors.brand700,
      AppButtonVariant.danger => AppColors.surface0,
    };
  }

  // En el botón secundario el texto es tinta y el icono va en color de marca.
  Color _iconColor(Color fg) =>
      variant == AppButtonVariant.secondary && !_isDisabled ? AppColors.brand700 : fg;

  Border? _border() {
    if (_isDisabled) return null;
    return switch (variant) {
      AppButtonVariant.outline =>
        Border.all(color: AppColors.brand700, width: AppSpacing.strokeDivider),
      AppButtonVariant.secondary =>
        Border.all(color: AppColors.line300, width: AppSpacing.strokeCard),
      _ => null,
    };
  }
}

/// Medidas de cada tamaño tomadas de los nodos de Figma.
class _ButtonSpec {
  const _ButtonSpec({
    required this.height,
    required this.radius,
    required this.paddingH,
    required this.gap,
    required this.iconGap,
    required this.iconSize,
    required this.textStyle,
  });

  final double height;
  final double radius;
  final double paddingH;
  final double gap;
  final double iconGap;
  final double iconSize;
  final TextStyle textStyle;

  static _ButtonSpec of(AppButtonSize size) => switch (size) {
        // Nodo 2027:238 "Acción del pedido".
        AppButtonSize.sm => _ButtonSpec(
            height: 32,
            radius: AppSpacing.radiusButton,
            paddingH: 14,
            gap: 6,
            iconGap: 6,
            iconSize: 16,
            textStyle: AppTypography.buttonText,
          ),
        // Nodos 66:14877 / 66:14611 (pie de pantalla) y 54:4 (con icono).
        AppButtonSize.md => _ButtonSpec(
            height: 48,
            radius: AppSpacing.radiusButton,
            paddingH: 16,
            gap: 6,
            iconGap: 10,
            iconSize: 18,
            textStyle: AppTypography.titleSmall,
          ),
        // Nodos 14:44 / 93:105 (Registro / Login). Roboto 600 17/19.9 no
        // tiene token propio en el tema.
        AppButtonSize.lg => _ButtonSpec(
            height: 56,
            radius: 32,
            paddingH: 24,
            gap: 10,
            iconGap: 10,
            iconSize: 20,
            textStyle: AppTypography.titleSmall.copyWith(
              fontSize: 17,
              height: 19.9 / 17,
            ),
          ),
      };
}

/// Chevron de avance de 6×11 con trazo de 1.7 y extremos redondeados.
class _Chevron extends StatelessWidget {
  const _Chevron({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 6,
      height: 11,
      child: CustomPaint(painter: _ChevronPainter(color)),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // El vector de Figma mide 6×11 en su eje; el trazo sobresale como allí.
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.strokeIcon
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => oldDelegate.color != color;
}

/// Avance del botón grande: `chevron-right` de 20 sin fondo, en una caja de
/// 32 para conservar el centrado de la etiqueta.
class _HeroArrow extends StatelessWidget {
  const _HeroArrow({this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Icon(icon ?? LucideIcons.chevronRight, size: 20, color: AppColors.surface0),
    );
  }
}

