import '../../core/models/models.dart';

/// Datos personales mostrados en "Mi perfil" y en la cuenta.
class AccountProfile {
  const AccountProfile({
    required this.name,
    required this.initials,
    required this.email,
    required this.phone,
    required this.zone,
  });

  final String name;
  final String initials;
  final String email;
  final String phone;
  final String zone;

  /// Perfil de ejemplo para cada rol; el del propietario es el de Figma.
  static AccountProfile forRole(UserRole role) => switch (role) {
        UserRole.client => const AccountProfile(
            name: 'Juan Pérez',
            initials: 'JP',
            email: 'juan@correo.com',
            phone: '+57 300 123 4567',
            zone: 'Bogotá D.C.',
          ),
        UserRole.contractor => const AccountProfile(
            name: 'Carlos Mendoza',
            initials: 'CM',
            email: 'carlos.mendoza.pinturas@ejemplo.com',
            phone: '+57 310 456 7890',
            zone: 'Cali, Valle del Cauca',
          ),
        UserRole.supplier => const AccountProfile(
            name: 'Pinturas del Valle',
            initials: 'PV',
            email: 'ventas@pinturasdelvalle.com',
            phone: '+57 602 555 0123',
            zone: 'Cali, Valle del Cauca',
          ),
      };
}
