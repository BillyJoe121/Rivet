import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../projects/widgets/client_kit/client_kit.dart';
import 'auth_widgets.dart';

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
            if (i > 1) const SizedBox(width: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              width: i == step ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i <= step ? RvColors.brand700 : AuthColors.fieldStroke,
                borderRadius: BorderRadius.circular(4),
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
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
      decoration: BoxDecoration(
        color: RvColors.brandLight,
        border: Border.all(color: RvColors.brand700.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: RvColors.brandGradient,
              shape: BoxShape.circle,
            ),
            child: const RvIcon(RvIcons.check, color: RvColors.surface0),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: rvText(
                15,
                weight: FontWeight.w600,
                lineHeight: 18,
                color: AuthColors.labelInk,
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
                width: 44,
                height: 44,
                child: Center(
                  child: RvIcon(
                    RvIcons.pencil,
                    size: 18,
                    color: RvColors.brand700,
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
          borderRadius: BorderRadius.circular(14),
          splashColor: RvColors.brand700.withValues(alpha: 0.10),
          highlightColor: RvColors.brand700.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              color: RvColors.surface0,
              border: Border.all(
                color: ready
                    ? RvColors.brand700.withValues(alpha: 0.35)
                    : AuthColors.fieldStroke,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 62),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      style: rvText(
                        15,
                        weight: ready ? FontWeight.w600 : FontWeight.w500,
                        lineHeight: 18,
                        color: ready ? RvColors.brand700 : AuthColors.placeholder,
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
            strokeWidth: 3,
            strokeCap: StrokeCap.round,
            backgroundColor: AuthColors.fieldStroke,
            color: RvColors.brand700,
          ),
          Center(
            child: Text(
              '$remaining',
              style: rvText(
                11,
                weight: FontWeight.w600,
                lineHeight: 13,
                color: AuthColors.labelInk,
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
        color: RvColors.brandLight,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.refresh_rounded, size: 20, color: RvColors.brand700),
    );
  }
}
