import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'contractor_account_mock.dart';
import 'edit_professional_profile_screen.dart';
import 'widgets/account_action_buttons.dart';
import 'widgets/account_profile_widgets.dart';

/// Perfil profesional del contratista como lo ve el cliente (Figma 22:143685).
class ProfessionalProfileScreen extends StatelessWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = ContractorAccountMock.services;
    return ProScreen(
      backgroundAsset: ProAssets.headerRoller,
      bottomNav: const ProBottomNav(active: ProNavDestination.home),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ProfileHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                _SummaryCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfessionalProfileScreen()),
                  ),
                ),
                _Notice(),
                const ProSectionHeader('Servicios principales'),
                SizedBox(
                  height: 76,
                  child: Row(
                    spacing: 8,
                    children: [
                      for (final s in m)
                        Expanded(
                          child: ProfileServiceTile(icon: s.icon, title: s.title, scope: s.scope),
                        ),
                    ],
                  ),
                ),
                const ProSectionHeader('Portafolio de proyectos', linkLabel: 'Ver todos'),
                SizedBox(
                  height: 149,
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final g in ContractorAccountMock.gallery)
                        Expanded(child: ProfileGalleryTile(image: g.image, caption: g.caption)),
                    ],
                  ),
                ),
                const AccountGradientButton('Solicitar visita'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Título con botón de regreso en línea: Volver en y=44 y título en y=38.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ProLayout.headerPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 8), child: ProBackButton(lucide: true)),
            const SizedBox(width: 6),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('Perfil profesional', style: ProText.pageTitle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de resumen: foto circular, datos y chevron, todo tocable.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 86,
      padding: const EdgeInsets.all(10),
      radius: ProRadii.lg,
      onTap: onTap,
      child: Row(
        children: [
          const ProImage(ProAssets.avatarCarlos, width: 60, height: 60, radius: 30),
          const SizedBox(width: 10),
          const Expanded(
            child: ProfileSummaryText(
              name: ContractorAccountMock.name,
              trade: ContractorAccountMock.trade,
              zone: ContractorAccountMock.zone,
              rating: ContractorAccountMock.rating,
            ),
          ),
          const SizedBox(width: 10),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

/// Aviso de disponibilidad en fondo ámbar suave.
class _Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ProColors.warningLight, borderRadius: BorderRadius.circular(ProRadii.md)),
      child: Row(
        children: [
          const ProIcon(LucideIcon.circleAlert, size: 23, color: ProColors.sun300),
          const SizedBox(width: 10),
          Expanded(child: Text('Disponibilidad por confirmar', style: ProText.r(12, color: ProColors.ink500, lineHeight: 14.4))),
        ],
      ),
    );
  }
}
