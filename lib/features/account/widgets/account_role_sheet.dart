import 'package:flutter/material.dart';

import '../../../core/models/models.dart';
import '../../home/widgets/kit/kit.dart';

/// Hoja inferior para cambiar el rol activo y recorrer la app desde las tres
/// perspectivas. Se abre al tocar el avatar del perfil.
Future<void> showAccountRoleSheet(
  BuildContext context, {
  required UserRole currentRole,
  required ValueChanged<UserRole> onSwitchRole,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: ProColors.paper100,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(ProRadii.lg))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Text('Cambiar rol activo', style: ProText.serifTitle),
            Text('Permite probar y navegar la app como Cliente o Contratista.', style: ProText.caption),
            const SizedBox(height: 4),
            for (final role in const [UserRole.client, UserRole.contractor])
              ProCard(
                borderColor: role == currentRole ? ProColors.brand700 : ProColors.line300,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onSwitchRole(role);
                },
                child: ProOptionRow(
                  icon: switch (role) {
                    UserRole.client => LucideIcon.house,
                    UserRole.contractor => LucideIcon.paintRoller,
                    UserRole.supplier => LucideIcon.store,
                  },
                  title: role.label,
                  subtitle: role.description,
                  showDivider: false,
                  trailing: role == currentRole ? const ProIcon(LucideIcon.circleCheck, size: 18) : null,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
