import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design_system/design_system.dart';

/// Indicador de pasos en píldoras: el paso actual se alarga, los pendientes
/// quedan como punto en el trazo de los campos.
class ForgotStepBar extends StatelessWidget {
  const ForgotStepBar({super.key, required this.step, this.total = 2});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Paso $step de $total',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= total; i++) ...[
            if (i > 1) const SizedBox(width: AppSpacing.space6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              width: i == step
                  ? AppSpacing.stepDotActiveWidth
                  : AppSpacing.stepDotSize,
              height: AppSpacing.stepDotSize,
              decoration: BoxDecoration(
                color: i <= step ? AppColors.brand700 : AppColors.fieldBorder,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Correo al que se envió el enlace, con sello de confirmación y acción
/// para corregirlo.
class SentEmailChip extends StatelessWidget {
  const SentEmailChip({super.key, required this.email, required this.onEdit});

  final String email;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSpacing.authFieldMinHeight),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sectionGap,
        AppSpacing.space10,
        AppSpacing.xs,
        AppSpacing.space10,
      ),
      decoration: BoxDecoration(
        color: AppColors.brandLight,
        border: Border.all(color: AppColors.brand700.withValues(alpha: 0.18)),
        borderRadius: AppSpacing.roundedCard,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.iconTileSize,
            height: AppSpacing.iconTileSize,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradientDiagonal,
              shape: BoxShape.circle,
            ),
            child: const RvIcon(RvIcons.check, color: AppColors.surface0),
          ),
          const SizedBox(width: AppSpacing.sectionGap),
          Expanded(
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.style(
                15,
                weight: FontWeight.w600,
                lineHeight: 18,
                color: AppColors.inputInk,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Cambiar correo',
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.selectionClick();
                onEdit();
              },
              child: const SizedBox(
                width: AppSpacing.resendButtonSize,
                height: AppSpacing.resendButtonSize,
                child: Center(
                  child: RvIcon(
                    RvIcons.pencil,
                    size: AppSpacing.iconSm,
                    color: AppColors.brand700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reenvío con anillo de cuenta regresiva: el anillo se vacía con el tiempo
/// y al terminar se convierte en la acción de reenviar.
class ResendCountdownTile extends StatelessWidget {
  const ResendCountdownTile({
    super.key,
    required this.remaining,
    required this.total,
    required this.onResend,
  });

  final int remaining;
  final int total;
  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    final ready = remaining == 0 && onResend != null;

    return Semantics(
      button: true,
      enabled: ready,
      label: ready
          ? 'Reenviar enlace'
          : 'Reenviar enlace en $remaining segundos',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ready ? onResend : null,
          borderRadius: AppSpacing.roundedCard,
          splashColor: AppColors.brand700.withValues(alpha: 0.10),
          highlightColor: AppColors.brand700.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface0,
              border: Border.all(
                color: ready
                    ? AppColors.brand700.withValues(alpha: 0.35)
                    : AppColors.fieldBorder,
              ),
              borderRadius: AppSpacing.roundedCard,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: AppSpacing.authFieldMinHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sectionGap,
                vertical: AppSpacing.space10,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: AppSpacing.iconTileSize,
                    height: AppSpacing.iconTileSize,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: ready
                          ? const _ResendBadge(key: ValueKey('ready'))
                          : _CountdownRing(
                              key: const ValueKey('ring'),
                              remaining: remaining,
                              total: total,
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sectionGap),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      style: AppTypography.style(
                        15,
                        weight: ready ? FontWeight.w600 : FontWeight.w500,
                        lineHeight: 18,
                        color: ready ? AppColors.brand700 : AppColors.inputPlaceholder,
                      ),
                      child: const Text('Reenviar enlace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    super.key,
    required this.remaining,
    required this.total,
  });

  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    final target = total == 0 ? 0.0 : remaining / total;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: target),
      duration: const Duration(seconds: 1),
      builder: (context, value, _) => Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: AppSpacing.strokeRing,
            strokeCap: StrokeCap.round,
            backgroundColor: AppColors.fieldBorder,
            color: AppColors.brand700,
          ),
          Center(
            child: Text(
              '$remaining',
              style: AppTypography.style(
                11,
                weight: FontWeight.w600,
                lineHeight: 13,
                color: AppColors.inputInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResendBadge extends StatelessWidget {
  const _ResendBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.brandLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.refresh_rounded,
        size: AppSpacing.iconMd,
        color: AppColors.brand700,
      ),
    );
  }
}
