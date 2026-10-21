import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/app_page_route.dart';
import '../auth/login_screen.dart';
import '../projects/widgets/client_kit/client_kit.dart';

/// Selección de rol (Sprint 1):
/// Poda oficial de roles de 3 a 2 (Cliente y Contratista).
/// Cuenta con cabecera informativa, tarjetas táctiles con feedback visual y transición fluida.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const _roles = [
    (
      role: UserRole.client,
      label: 'Cliente',
      tag: 'Propietario de Obra',
      desc: 'Publica espacios, recibe y compara ofertas transparentes de contratistas.',
      image: RvImages.portraitManCap,
    ),
    (
      role: UserRole.contractor,
      label: 'Contratista',
      tag: 'Profesional de Acabados',
      desc: 'Postula cotizaciones desglosando tu mano de obra de los materiales oficiales.',
      image: RvImages.portraitPainterSmiling,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF004E49), Color(0xFF0A5F54), Color(0xFF0B6B5A)],
            stops: [0, 0.58, 1],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        alignment: Alignment.center,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Cómo usarás Rivet?',
                textAlign: TextAlign.center,
                style: rvText(
                  28,
                  weight: FontWeight.w700,
                  lineHeight: 33.6,
                  color: RvColors.paper100,
                  family: RvFonts.serif,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona tu perfil para personalizar tu experiencia',
                textAlign: TextAlign.center,
                style: rvText(
                  15,
                  weight: FontWeight.w400,
                  lineHeight: 20.0,
                  color: const Color(0xFFDCE8E4),
                ),
              ),
              const SizedBox(height: 28),
              for (var i = 0; i < _roles.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _RoleCard(
                  label: _roles[i].label,
                  tag: _roles[i].tag,
                  desc: _roles[i].desc,
                  image: _roles[i].image,
                  onTap: () => AppNavigator.push(
                    context,
                    LoginScreen(role: _roles[i].role),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.tag,
    required this.desc,
    required this.image,
    required this.onTap,
  });

  final String label;
  final String tag;
  final String desc;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $desc',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RvRadii.xl),
          splashColor: RvColors.brand700.withValues(alpha: 0.1),
          highlightColor: RvColors.brand700.withValues(alpha: 0.05),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RvColors.surface0,
              borderRadius: BorderRadius.circular(RvRadii.xl),
              border: Border.all(color: const Color(0xFFDCE8E4), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 10),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    image,
                    width: 110,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5F0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: rvText(
                            11,
                            weight: FontWeight.w600,
                            lineHeight: 14,
                            color: RvColors.brand700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: rvText(
                          22,
                          weight: FontWeight.w700,
                          lineHeight: 26,
                          color: RvColors.ink900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: rvText(
                          12,
                          weight: FontWeight.w400,
                          lineHeight: 16,
                          color: RvColors.ink500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: RvColors.brand700,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
