import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../auth/login_screen.dart';
import '../projects/widgets/client_kit/client_kit.dart';

/// Selección de rol (Figma 59:3): fondo con gradiente de marca y tres
/// tarjetas de 368×188 (foto de 160 y nombre del rol). Tocar una tarjeta
/// abre el inicio de sesión con ese rol.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const _roles = [
    (role: UserRole.client, label: 'Cliente', image: RvImages.portraitManCap),
    (role: UserRole.contractor, label: 'Contratista', image: RvImages.portraitPainterSmiling),
    (role: UserRole.supplier, label: 'Proveedor', image: RvImages.ferreCasaFront),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _roles.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _RoleCard(
                label: _roles[i].label,
                image: _roles[i].image,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen(role: _roles[i].role)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.label, required this.image, required this.onTap});

  final String label;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: RvCard(
        onTap: onTap,
        height: 188,
        radius: RvRadii.xl,
        borderColor: const Color(0xFFDCE8E4),
        borderWidth: 1,
        padding: const EdgeInsets.all(14),
        shadow: const [BoxShadow(color: Color(0x14000000), offset: Offset(0, 10), blurRadius: 24)],
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(image, width: 160, height: 160, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: rvText(24, weight: FontWeight.w700, lineHeight: 27.6)),
            ),
          ],
        ),
      ),
    );
  }
}
