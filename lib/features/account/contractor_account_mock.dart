import '../home/widgets/kit/kit.dart';

/// Datos simulados del perfil profesional del contratista.
abstract final class ContractorAccountMock {
  static const String name = 'Carlos Ramírez';
  static const String initials = 'CR';
  static const String trade = 'Pintor y estucador';
  static const String zone = '♧ Medellín y alrededores';
  static const String rating = '⭐ 4.8 (32 reseñas)     ◇ 5 años';
  static const String bio =
      'Pintor y estucador con 5 años de experiencia en viviendas y espacios comerciales. '
      'Ofrezco acabados de alta calidad y soluciones personalizadas.';
  static const String phone = '+57 300 123 4567';
  static const String email = 'juan@correo.com';
  static const String city = 'Medellín, Antioquia';
  static const String availability = 'Disponible esta semana';
  static const List<String> zones = ['Medellín', 'Envigado', 'Bello'];

  static const List<ProfileService> services = [
    ProfileService(LucideIcon.paintRoller, 'Pintura interior', 'Viviendas y oficinas'),
    ProfileService(LucideIcon.house, 'Pintura exterior', 'Fachadas y terrazas'),
    ProfileService(LucideIcon.paintbrush, 'Estuco y acabados', 'Muros y cielorrasos'),
  ];

  static const List<ProfileGalleryItem> gallery = [
    ProfileGalleryItem(ProAssets.greenLivingRoom, 'Sala residencial\nPintura interior'),
    ProfileGalleryItem(ProAssets.facade, 'Fachada moderna\nPintura exterior'),
    ProfileGalleryItem(ProAssets.greenWall, 'Acabado de estuco\nEstuco'),
  ];
}

/// Servicio ofrecido: ícono, título y alcance.
class ProfileService {
  const ProfileService(this.icon, this.title, this.scope);

  final LucideIcon icon;
  final String title;
  final String scope;
}

/// Foto de la galería de portafolio con su descripción.
class ProfileGalleryItem {
  const ProfileGalleryItem(this.image, this.caption);

  final String image;
  final String caption;
}
