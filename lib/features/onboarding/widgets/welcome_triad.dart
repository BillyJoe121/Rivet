import 'package:flutter/material.dart';

import '../../projects/widgets/client_kit/client_kit.dart';

/// Los tres actores de Rivet unidos por una línea: la obra del propietario,
/// el contratista y la Bodega Oficial. La bodega lleva el sello sólido.
class WelcomeTriad extends StatelessWidget {
  const WelcomeTriad({super.key});

  static const _nodeSize = 52.0;

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TriadNode(icon: RvIcons.house, label: 'Tu obra'),
        _TriadLink(),
        _TriadNode(icon: RvIcons.hardHat, label: 'Contratista'),
        _TriadLink(),
        _TriadNode(icon: RvIcons.package, label: 'Bodega', solid: true),
      ],
    );
  }
}

class _TriadNode extends StatelessWidget {
  const _TriadNode({
    required this.icon,
    required this.label,
    this.solid = false,
  });

  final RvIconData icon;
  final String label;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: WelcomeTriad._nodeSize,
            height: WelcomeTriad._nodeSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: solid
                  ? RvColors.paper100
                  : Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                color: Colors.white.withValues(alpha: solid ? 0 : 0.32),
              ),
            ),
            child: RvIcon(
              icon,
              size: 22,
              color: solid ? RvColors.brand700 : RvColors.paper100,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: rvText(
              12,
              weight: FontWeight.w500,
              lineHeight: 14,
              color: const Color(0xFFDCE8E4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TriadLink extends StatelessWidget {
  const _TriadLink();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: WelcomeTriad._nodeSize / 2),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
