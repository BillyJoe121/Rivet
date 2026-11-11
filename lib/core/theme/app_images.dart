/// Imágenes de cabecera de las pantallas, exportadas del Figma a 1236×696
/// (3× del bloque de 412×232). La forma orgánica y el fundido al lienzo
/// vienen incluidos en la imagen.
abstract final class AppHeroImages {
  static const String planning = 'assets/hero/hero_planning.jpg'; // Plano, superficies, negociación
  static const String livingRoom = 'assets/hero/hero_living_room.jpg'; // Login, mi perfil
  static const String documents = 'assets/hero/hero_documents.jpg'; // Propuestas y acuerdos
  static const String storefront = 'assets/hero/hero_storefront.jpg'; // Proveedor, catálogo, comparar
  static const String privacy = 'assets/hero/hero_privacy.jpg'; // Autorización de IA
  static const String home = 'assets/hero/hero_home.jpg'; // Explorar, seguimiento, avance
  static const String greenery = 'assets/hero/hero_greenery.jpg'; // Inicios por rol, detalle de propuesta
  static const String lounge = 'assets/hero/hero_lounge.jpg'; // Detalle privado, problemas, cierre
  static const String trust = 'assets/hero/hero_trust.jpg'; // Pagos y cuenta
  static const String paintShelf = 'assets/hero/hero_paint_shelf.jpg'; // Pedidos de materiales
  static const String messages = 'assets/hero/hero_messages.jpg'; // Mensajes y notificaciones
  static const String paintRoller = 'assets/hero/hero_paint_roller.jpg'; // Elegir proveedor, visitas

  static const List<String> all = [
    planning, livingRoom, documents, storefront, privacy, home,
    greenery, lounge, trust, paintShelf, messages, paintRoller,
  ];
}

/// Ilustraciones y fotografías exportadas de Figma. Las cabeceras miden
/// 412×232; el comentario indica el prefijo del `imageRef` de Figma.
abstract final class AppImages {
  // Ilustraciones de cabecera (412×232).
  static const String headerBotanical = 'Fondos/Rincón botánico minimalista en tonos pastel.png'; // 8d999b3dc1
  static const String headerStore = 'Fondos/Tienda minimalista entre plantas verdes.png'; // 40f4acc0af
  static const String headerRenovation = 'Fondos/Vigneta de renovación en tonos pastel.png'; // 1980ecef37
  static const String headerRoller = 'Fondos/Rodillo sobre pincelada verde.png'; // f8b86b4306
  static const String headerLivingSoft = 'Fondos/Sala minimalista con plantas y luz suave.png'; // 679fb7ca62
  static const String headerPrivacy = 'Fondos/Escudo de privacidad junto a plantas.png'; // b236addf7d
  static const String headerTrust = 'Fondos/Escudo de confianza entre hojas verdes.png'; // 4bdb2ed74d
  static const String headerGreenCream = 'Fondos/Salón Minimalista en Verde y Crema.png'; // ac78efbe72
  static const String headerPapers = 'Fondos/Papeles y plantas sobre fondo crema.png'; // 3585a4aa1e
  static const String headerPaintCorner = 'Fondos/Rincón natural de pintura DIY.png';
  static const String headerChat = 'Fondos/Burbuja de chat y campana entre hojas.png';
  static const String loginScandinavian = 'Fondos/Sala escandinava bañada de sol.png'; // 31446ae1f3
  static const String landscapeLake = 'Fondos/Refugio Mediterráneo con Vista al Lago.png'; // 41903dcb1e

  // Fotografías y miniaturas.
  static const String paintingLivingRoom = 'Fondos/foto_pintando_sala.jpg'; // 086d0a6ff4
  static const String maskingTape = 'Fondos/foto_cinta_enmascarar.jpg'; // 16bbc14bcf
  static const String greenWallVertical = 'Fondos/foto_pared_verde_vertical.jpg'; // 31778aaf7e
  static const String unfinishedWall = 'Fondos/foto_pared_sin_terminar.jpg'; // 43e199c360
  static const String modernHouse = 'Fondos/foto_fachada_casa_moderna.jpg'; // 45a1fe8340
  static const String brightKitchen = 'Fondos/foto_cocina_luminosa.jpg'; // 5798aebaab
  static const String livingDining = 'Fondos/foto_sala_comedor.jpg'; // 6fbc783b61
  static const String brightBathroom = 'Fondos/foto_bano_claro.jpg'; // 7f0560937e
  static const String paintCorona = 'Fondos/foto_pintura_corona.jpg'; // 7f2c9753b9
  static const String stuccoCorona = 'Fondos/foto_estuco_corona.jpg'; // 81712f1d2d
  static const String pergolaTerrace = 'Fondos/foto_terraza_pergola.jpg'; // 918f1a2445
  static const String emptyGreenRoom = 'Fondos/foto_sala_vacia_verde.jpg'; // 9bcb483bc9
  static const String dampWall = 'Fondos/foto_pared_humedad.jpg'; // b42f2783f6
  static const String sofaGreenWall = 'Fondos/foto_sala_sofa_verde.jpg'; // b718df4594
  static const String portraitPainterWoman = 'Fondos/foto_retrato_pintora.jpg'; // c83b3d680f
  static const String paintRivetPremium = 'Fondos/foto_pintura_rivet_premium.jpg'; // ca3b2024fb
  static const String emptyRoomWindow = 'Fondos/foto_sala_vacia_ventana.jpg'; // cdd73fe35b
  static const String mailEnvelope = 'Fondos/foto_sobre_correo.jpg'; // f15ae6a2d9

  // Fotografías de las pantallas del contratista y del proveedor.
  static const String proKitchen = 'Fondos/pro-cocina.jpg';
  static const String proFacade = 'Fondos/pro-fachada.jpg';
  static const String proModernHouse = 'Fondos/pro-casa-moderna.jpg';
  static const String proLivingRoomTall = 'Fondos/pro-sala-vertical.jpg';
  static const String proAvatarCarlos = 'Fondos/pro-avatar-carlos.jpg';
  static const String proAvatarPainter = 'Fondos/pro-avatar-pintora.jpg';
  static const String proRivetPaint = 'Fondos/pro-pintura-rivet.jpg';
  static const String proCoronaStucco = 'Fondos/pro-estuco-corona.jpg';
  static const String proMaskingTape = 'Fondos/pro-cinta-enmascarar.jpg';
}
