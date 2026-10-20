<!-- converted from 03-pantallas-y-trazabilidad.docx -->

Pantallas y trazabilidad de Rivet
Propuesta de aplicación móvil Flutter
12 de octubre de 2026  |  Versión 1.0
Este catálogo describe las pantallas de la propuesta Flutter y su relación con los requisitos funcionales. Cliente, contratista y proveedor comparten una aplicación con accesos por rol; administración es una superficie interna. Una pantalla puede tener variantes por rol sin exponer datos privados de otros participantes.
# Convenciones y estados comunes
P identifica una pantalla; RF identifica un requisito del documento 02. V1 corresponde al prototipo académico y V2 a funciones propuestas para evaluar después. Modales de confirmación y estados transitorios pertenecen a su pantalla, no se cuentan como productos separados.
Toda pantalla contempla carga, vacío, error, sesión vencida y permiso insuficiente cuando aplique. La recuperación conserva borradores; las acciones financieras permanecen deshabilitadas sin conexión o confirmación válida. En V1, cobros y desembolsos se identifican como simulados.
# P 001 Acceso
Actores y alcance: Todos · V1. Entrar a la cuenta y llegar al inicio de su rol.
Datos y acciones: Credenciales; iniciar sesión, ir a registro o recuperación. No ofrece selección de administrador.
Estados y recuperación: Sesión vencida, credenciales incorrectas y acceso pendiente; conservar la pantalla sin revelar cuentas.
RF asociados: RF-002, RF-074.
# P 002 Registro
Actores y alcance: Cliente, contratista, proveedor · V1. Crear una cuenta con rol inicial y datos de contacto.
Datos y acciones: Nombre, contacto y credenciales; seleccionar rol y confirmar registro. La tarifa profesional necesita autorización aparte.
Estados y recuperación: Campos inválidos, cuenta pendiente y registro confirmado; no conceder privilegios administrativos.
RF asociados: RF-001, RF-074.
# P 003 Recuperación de acceso
Actores y alcance: Todos · V1. Solicitar recuperación por el canal registrado.
Datos y acciones: Contacto; solicitar instrucciones y volver al acceso.
Estados y recuperación: Mensaje uniforme de solicitud recibida, error de canal o enlace vencido; repetir sin revelar identidad ajena.
RF asociados: RF-003.
# P 004 Inicio por rol
Actores y alcance: Cliente, contratista, proveedor · V1. Consultar las tareas relevantes y continuar trabajos.
Datos y acciones: Cliente: proyectos y ofertas; contratista: solicitudes y propuestas; proveedor: catálogo y pedidos. Abrir el flujo correspondiente.
Estados y recuperación: Primer uso, sin actividad o datos desactualizados; conservar borradores y distinguir saldo de dinero disponible.
RF asociados: RF-009, RF-017, RF-023, RF-035, RF-044, RF-068.
# P 005 Perfil del cliente
Actores y alcance: Cliente · V1. Mantener los datos necesarios para sus proyectos.
Datos y acciones: Nombre visible, contacto y zona; editar y guardar. La dirección exacta queda en un flujo privado.
Estados y recuperación: Perfil incompleto, error de guardado y datos guardados; no alterar cotizaciones existentes.
RF asociados: RF-004, RF-007, RF-074.
# P 006 Perfil y portafolio profesional
Actores y alcance: Contratista y cliente lector · V1. Presentar servicios, experiencia, trabajos y reseñas; permite al cliente evaluar una visita.
Datos y acciones: Servicios, zona, fotos de portafolio y datos declarados; editar como propietario, consultar como cliente y solicitar visita.
Estados y recuperación: Sin portafolio, carga fallida y disponibilidad por confirmar; solo distintivos con respaldo específico.
RF asociados: RF-005, RF-007, RF-024, RF-025, RF-074.
# P 007 Perfil comercial del proveedor
Actores y alcance: Proveedor y compradores lectores · V1. Identificar el comercio y sus referencias publicadas.
Datos y acciones: Nombre comercial, contacto, zona y evidencia aportada; editar perfil y consultar catálogo.
Estados y recuperación: Perfil incompleto, respaldo pendiente o referencia desactivada; no insinuar autenticidad certificada.
RF asociados: RF-006, RF-017, RF-022, RF-074.
# P 008 Crear o editar proyecto
Actores y alcance: Cliente · V1. Definir un trabajo de pintura o estuco antes de publicarlo.
Datos y acciones: Título, tipo de trabajo, ciudad y zona; guardar borrador, añadir superficies o continuar captura.
Estados y recuperación: Borrador incompleto, cambios sin guardar y guardado fallido; recuperar sin publicar automáticamente.
RF asociados: RF-009, RF-007.
# P 009 Superficies y medidas
Actores y alcance: Cliente · V1. Describir cada pared o zona una sola vez.
Datos y acciones: Identificador, descripción, ancho, alto, unidad, aberturas y estado; añadir, corregir o eliminar superficie y vincular fotos.
Estados y recuperación: Medida inválida, área pendiente y superficie guardada; varias fotos no multiplican el área.
RF asociados: RF-010, RF-011, RF-066.
# P 010 Captura y carga de fotos
Actores y alcance: Cliente · V1. Adjuntar imágenes a una superficie identificada.
Datos y acciones: Cámara o archivos, notas y superficie de destino; capturar, cargar, revisar o retirar. Solicitar permisos cuando corresponda.
Estados y recuperación: Permiso denegado, carga incompleta o fallida; conservar la asociación y permitir reintento.
RF asociados: RF-011, RF-012, RF-015, RF-074.
# P 011 Autorización y uso de IA
Actores y alcance: Cliente · V1. Explicar procesamiento y publicación antes de enviar imágenes.
Datos y acciones: Proveedor de procesamiento, finalidad, acceso, conservación configurada y límite de generaciones; aceptar o rechazar y corregir manualmente.
Estados y recuperación: Sin autorización no iniciar procesamiento; política o costo máximo pendiente se identifica antes de avanzar.
RF asociados: RF-008, RF-012, RF-067.
# P 012 Revisión de imagen minimizada
Actores y alcance: Cliente · V1. Elegir la versión que puede compartirse con contratistas.
Datos y acciones: Original privado, derivado y marcas de zonas generadas u ocultas; ocultar elementos, revisar, rechazar, corregir o aprobar.
Estados y recuperación: Procesando, edición fallida o defectos alterados; no publicar el derivado hasta aprobar, ofrecer alternativa manual.
RF asociados: RF-013, RF-014, RF-015, RF-074.
# P 013 Dossier y esquema del espacio
Actores y alcance: Cliente y contratista autorizado · V1. Reunir superficies, imágenes aprobadas y representación básica para cotizar.
Datos y acciones: Medidas, disposición confirmada, aberturas y supuestos; consultar esquema3D paramétrico y corregir sus datos de origen.
Estados y recuperación: Geometría incompleta o distribución desconocida; mostrar esquema aproximado sin inventar espacios ocultos.
RF asociados: RF-016, RF-015, RF-066, RF-074.
# P 014 Rango y lista estimada de materiales
Actores y alcance: Cliente y contratista autorizado · V1. Relacionar cantidades orientativas con productos y trabajo solicitado.
Datos y acciones: Áreas, capas, rendimiento, referencia técnica, pérdidas y rango; confirmar supuestos, elegir producto y proponer correcciones.
Estados y recuperación: Ficha ausente, unidades incompatibles o datos insuficientes; pedir información y no emitir certeza ficticia.
RF asociados: RF-018, RF-031, RF-066.
# P 015 Revisión y publicación del proyecto
Actores y alcance: Cliente · V1. Mostrar exactamente qué podrán ver los profesionales.
Datos y acciones: Dossier minimizado, zona, alcance y presupuesto orientativo; previsualizar, corregir y publicar gratis.
Estados y recuperación: Contenido pendiente o foto no aprobada bloquean publicar; la dirección y originales permanecen privados.
RF asociados: RF-007, RF-015, RF-034, RF-067, RF-074.
# P 016 Mis proyectos
Actores y alcance: Cliente · V1. Seguir borradores, proyectos publicados y contrataciones.
Datos y acciones: Lista por estado y fecha; abrir, editar borrador, comparar ofertas y consultar avisos.
Estados y recuperación: Sin proyectos, carga incompleta y fecha vencida; no liberar fondos desde una tarjeta.
RF asociados: RF-009, RF-034, RF-035, RF-041, RF-068.
# P 017 Proyectos disponibles
Actores y alcance: Contratista · V1. Encontrar trabajos por servicio y zona.
Datos y acciones: Filtros ciudad, barrio y oficio; consultar tarjetas y abrir dossier.
Estados y recuperación: Sin coincidencias, proyecto cerrado o contenido no autorizado; no revelar dirección o contacto privado.
RF asociados: RF-023, RF-074.
# P 018 Detalle del proyecto para cotizar
Actores y alcance: Contratista · V1. Evaluar el alcance y decidir si requiere aclaraciones o visita.
Datos y acciones: Fotos aprobadas, medidas, presupuesto y cantidades estimadas; preguntar, consultar materiales o crear propuesta.
Estados y recuperación: Publicado, en negociación o no disponible; distinguir datos aportados, generados y corregidos.
RF asociados: RF-016, RF-023, RF-029, RF-031, RF-066.
# P 019 Buscar profesionales
Actores y alcance: Cliente · V1. Explorar candidatos mediante tarjetas o lista.
Datos y acciones: Filtros por oficio y zona, experiencia y portafolio; abrir perfil y solicitar visita. Deslizar es opcional.
Estados y recuperación: Sin resultados, disponibilidad pendiente y error de consulta; no exigir un match mutuo para cotizar.
RF asociados: RF-024, RF-025.
# P 020 Solicitud de visita
Actores y alcance: Cliente y contratista · V1. Proponer inspección presencial con alcance y tarifa.
Datos y acciones: Profesional, proyecto opcional, fecha, duración y precio propuesto; enviar, responder y solicitar aclaraciones.
Estados y recuperación: Pendiente de acuerdo, propuesta recibida o rechazada; no cobrar ni compartir dirección antes de formalizar.
RF asociados: RF-025, RF-032.
# P 021 Acuerdo y agenda de visita
Actores y alcance: Cliente y contratista · V1. Confirmar condiciones y gestionar fecha de la visita.
Datos y acciones: Alcance, precio, fecha y reglas de cancelación configuradas; aceptar, proponer cambio y consultar dirección autorizada.
Estados y recuperación: Acordada, reprogramación pendiente o cancelación solicitada; exigir el acuerdo requerido por la política.
RF asociados: RF-025, RF-026, RF-027, RF-028, RF-074.
# P 022 Pago de visita
Actores y alcance: Cliente · V1. Revisar el total y registrar un pago de prueba de la visita acordada.
Datos y acciones: Precio, tarifa aplicable, condiciones y referencia; confirmar pago o volver al acuerdo.
Estados y recuperación: Simulado, pendiente, rechazado o por verificar; una pantalla de éxito no prueba recaudo.
RF asociados: RF-026, RF-033, RF-038, RF-051, RF-055.
# P 023 Catálogo de materiales
Actores y alcance: Cliente y contratista · V1. Consultar referencias y precios aplicables a su audiencia.
Datos y acciones: Producto, proveedor, presentación, precio y fecha; filtrar, abrir ficha o pedir disponibilidad.
Estados y recuperación: Precio vencido o disponibilidad por confirmar; acceso a tarifa profesional solo con autorización del proveedor.
RF asociados: RF-017, RF-019, RF-020, RF-022, RF-065, RF-074.
# P 024 Ficha de producto
Actores y alcance: Cliente y contratista · V1. Verificar la referencia incluida en una estimación o propuesta.
Datos y acciones: SKU, volumen, color, acabado, rendimiento y fuente; elegir cantidad, revisar vigencia y contactar proveedor.
Estados y recuperación: Ficha incompleta, producto desactivado o sin fuente; no equiparar catálogo con autenticidad del material físico.
RF asociados: RF-018, RF-019, RF-020, RF-022, RF-066.
# P 025 Gestión de catálogo y precios
Actores y alcance: Proveedor · V1. Crear y mantener ofertas de su propio comercio.
Datos y acciones: SKU, presentación, atributos, tarifas cliente/profesional, vigencia y disponibilidad; crear, editar, desactivar o responder confirmación.
Estados y recuperación: Campos faltantes, referencia duplicada, precio vencido o guardado fallido; mantener historial.
RF asociados: RF-006, RF-021, RF-062, RF-073, RF-074.
# P 026 Autorización de tarifa profesional
Actores y alcance: Proveedor y contratista solicitante · V1. Decidir quién recibe la tarifa especial de un proveedor.
Datos y acciones: Solicitud, profesional y estado; pedir acceso, aprobar o revocar con motivo.
Estados y recuperación: Pendiente, autorizada o revocada; el cambio aplica al acceso futuro y no reescribe cotizaciones fijadas.
RF asociados: RF-019, RF-065, RF-074.
# P 027 Crear propuesta profesional
Actores y alcance: Contratista · V1. Preparar una oferta sobre el dossier del cliente.
Datos y acciones: Superficies, tareas, exclusiones, plazo, vigencia, mano de obra y materiales; corregir cantidades con motivo, guardar o enviar.
Estados y recuperación: Borrador, pendiente de datos o enviado; informar cambios de producto o cantidad para comparación.
RF asociados: RF-029, RF-030, RF-031, RF-049.
# P 028 Detalle de cotización
Actores y alcance: Cliente y contratista · V1. Consultar cada propuesta con desglose y condiciones.
Datos y acciones: Cantidades, unitarios, mano de obra, materiales, disponibilidad, tarifa cliente y neto profesional según permiso; negociar, rechazar o aceptar.
Estados y recuperación: Vigente, vencida o fijada; diferenciar estimación, propuesta y precio confirmado sin exponer tarifas privadas ajenas.
RF asociados: RF-019, RF-030, RF-033, RF-036, RF-038, RF-049, RF-050, RF-073, RF-074.
# P 029 Comparación de ofertas
Actores y alcance: Cliente · V1. Comparar propuestas equivalentes y reconocer diferencias.
Datos y acciones: Profesional, alcance, producto, cantidad, unitario, total, fecha y cargos; seleccionar propuestas y abrir sus detalles.
Estados y recuperación: Una o varias ofertas, datos no confirmados y productos distintos; no ordenar como mejor solo por precio unitario.
RF asociados: RF-030, RF-031, RF-035, RF-073.
# P 030 Conversación y contrapropuestas
Actores y alcance: Cliente, contratista y proveedor según relación · V1. Resolver dudas y negociar con historial asociado al proyecto o pedido.
Datos y acciones: Mensajes, adjuntos autorizados y versiones; aclarar, enviar contrapropuesta y revisar el acuerdo antes de fijar.
Estados y recuperación: Mensaje pendiente o no enviado y propuesta modificada; reintentar sin duplicar versiones ni cobrar por mensajes.
RF asociados: RF-020, RF-032, RF-074.
# P 031 Resumen del acuerdo de trabajo
Actores y alcance: Cliente y contratista · V1. Confirmar la versión de alcance y cobros que regirá el trabajo.
Datos y acciones: Propuesta fijada, fechas, saldos separados, tarifa y comisión aplicables; aceptar ambos y pasar al pago.
Estados y recuperación: Pendiente de una parte o cambio requerido; una modificación crea versión y exige nueva aceptación.
RF asociados: RF-033, RF-036, RF-037, RF-038, RF-039, RF-073.
# P 032 Pago del proyecto
Actores y alcance: Cliente · V1. Confirmar el total acordado mediante entorno de prueba.
Datos y acciones: Resumen congelado, mano de obra, materiales, tarifa cliente y referencia; continuar al operador simulado y consultar estado.
Estados y recuperación: En proceso, rechazado o por confirmar; bloquear cargos reales si no hay condiciones y operador validados.
RF asociados: RF-037, RF-038, RF-039, RF-044, RF-051, RF-055, RF-073.
# P 033 Resultado y verificación del pago
Actores y alcance: Cliente, contratista y administración · V1. Mostrar el resultado verificado y su relación con el acuerdo.
Datos y acciones: Referencia, origen de confirmación, importe y saldos; actualizar estado, ver comprobante o reintentar cuando proceda.
Estados y recuperación: Pendiente, confirmado, discrepancia o duplicado; no crear un cargo nuevo hasta verificar el anterior.
RF asociados: RF-044, RF-051, RF-054, RF-055.
# P 034 Trabajo y cierre de mano de obra
Actores y alcance: Cliente y contratista · V1. Registrar progreso y las dos confirmaciones finales.
Datos y acciones: Alcance, evidencia, fecha, aprobación de cada parte y saldo pendiente; confirmar cumplimiento, proponer prórroga o pedir revisión.
Estados y recuperación: En ejecución, una aprobación, ambas aprobaciones o retrasado; vencer fecha no libera, estrellas no condicionan el pago.
RF asociados: RF-039, RF-040, RF-041, RF-043, RF-050, RF-056.
# P 035 Propuesta de nueva fecha
Actores y alcance: Cliente y contratista · V1. Acordar una extensión sin alterar el acuerdo unilateralmente.
Datos y acciones: Fecha vigente, nueva fecha, motivo y respuesta; proponer, aceptar o rechazar.
Estados y recuperación: Pendiente o rechazada mantiene la fecha original; aceptación mutua registra versión e historial.
RF asociados: RF-041, RF-042, RF-068.
# P 036 Solicitud y cotización de materiales
Actores y alcance: Cliente, contratista y proveedor · V1. Confirmar cantidades, responsable de compra y oferta del proveedor.
Datos y acciones: Líneas exactas, precio aplicable, vigencia, flete, cargos y destino privado; solicitar, responder, aceptar o corregir.
Estados y recuperación: Por confirmar, confirmada o no disponible; no crear pedido a partir de precio vencido sin aceptación.
RF asociados: RF-019, RF-020, RF-045, RF-046, RF-065, RF-073, RF-074.
# P 037 Entrega y recepción de materiales
Actores y alcance: Proveedor y destinatario autorizado · V1. Gestionar entrega y aceptación de insumos separadas del trabajo.
Datos y acciones: Fecha, despacho, cantidades recibidas y evidencia; marcar despacho, aceptar recepción o reportar faltantes/daños.
Estados y recuperación: Entrega parcial, recibida, aceptada o en revisión; pago de materiales sigue su propia aceptación.
RF asociados: RF-046, RF-047, RF-048, RF-057, RF-073, RF-074.
# P 038 Movimientos y liquidaciones
Actores y alcance: Cliente, contratista y proveedor según titularidad · V1. Consultar qué se pagó, qué está pendiente y el neto por destinatario.
Datos y acciones: Bruto, tarifas, comisiones, neto, referencias, fechas y entorno; abrir operación y consultar comprobante.
Estados y recuperación: Pendiente, liberación solicitada, simulado como liberado o por conciliar; fondos ajenos no son ingreso de la plataforma.
RF asociados: RF-038, RF-044, RF-048, RF-049, RF-050, RF-051, RF-054, RF-055, RF-073, RF-074.
# P 039 Cancelación y solicitud de devolución
Actores y alcance: Participantes del acuerdo · V1. Solicitar cancelación o reembolso con causa y condiciones conocidas.
Datos y acciones: Acuerdo, estado, motivo, importe solicitado y política; revisar efectos y confirmar solicitud.
Estados y recuperación: Solicitud abierta, aceptada, rechazada o por resolver; no prometer devolución ni deducir cargos no aprobados.
RF asociados: RF-028, RF-052, RF-053, RF-058.
# P 040 Crear incidencia
Actores y alcance: Cliente, contratista o proveedor · V1. Abrir un caso por incumplimiento, silencio o problema de entrega.
Datos y acciones: Operación afectada, categoría, descripción y evidencia; presentar reporte y obtener identificador.
Estados y recuperación: Validación pendiente, abierto o carga fallida; proteger adjuntos y conservar saldo afectado en revisión.
RF asociados: RF-043, RF-057, RF-074.
# P 041 Seguimiento de reclamación
Actores y alcance: Partes autorizadas y administrador · V1. Consultar evidencia solicitada, plazos y decisión del caso.
Datos y acciones: Historial, participantes, fechas y saldo afectado; responder solicitud de información y consultar resolución.
Estados y recuperación: Espera de información, revisión o resuelto; plazo sin configurar se informa y no simula una decisión automática.
RF asociados: RF-043, RF-058, RF-060, RF-074.
# P 042 Calificación del servicio
Actores y alcance: Cliente y contratista · V1. Registrar una reseña después de una transacción completada.
Datos y acciones: Calificación, comentario y servicio asociado; publicar o dejar para después.
Estados y recuperación: No elegible, pendiente de publicación o publicada; omitir reseña no bloquea una liberación ya aprobada.
RF asociados: RF-056.
# P 043 Notificaciones
Actores y alcance: Todos según evento autorizado · V1. Avisar novedades que necesitan una acción del participante.
Datos y acciones: Propuestas, pagos, entregas, vencimientos y prórrogas; abrir el detalle asociado y marcar leído.
Estados y recuperación: Sin eventos, notificación antigua o acceso expirado; no incluir dirección ni originales en vista pública.
RF asociados: RF-020, RF-041, RF-042, RF-068, RF-074.
# P 044 Ajustes de cuenta y datos
Actores y alcance: Titular de cuenta · V1. Revisar consentimiento, límites IA y solicitud de eliminación.
Datos y acciones: Autorizaciones, datos de cuenta, conservación pendiente de política y uso de generaciones; modificar consentimiento o solicitar eliminación.
Estados y recuperación: Solicitud en revisión, información retenida por obligación o error; explicar alcance y mantener historial requerido conforme a política.
RF asociados: RF-008, RF-067, RF-072, RF-074.
# P 045 Administración de usuarios y actividad
Actores y alcance: Administrador autorizado · V1. Supervisar cuentas, proyectos, catálogo y casos.
Datos y acciones: Listado por estado, referencias y conteos del periodo; abrir un registro y gestionar reportes con permisos.
Estados y recuperación: Sin registros, filtros vacíos o permiso insuficiente; acciones auditadas y datos limitados al propósito.
RF asociados: RF-059, RF-063, RF-074.
# P 046 Revisión administrativa de casos
Actores y alcance: Administrador autorizado · V1. Registrar una resolución fundada sin borrar movimientos anteriores.
Datos y acciones: Evidencias, respuestas, plazos y saldos; solicitar información, registrar motivo y resolver según política aprobada.
Estados y recuperación: Caso incompleto o pendiente de política; conservar responsable, fundamento y fecha de cada decisión.
RF asociados: RF-054, RF-058, RF-060, RF-074.
# P 047 Configuración de tarifas y políticas
Actores y alcance: Administrador autorizado · V1. Mantener parámetros comerciales y plazos con historial.
Datos y acciones: Base, tasa, recargo/deducción, vigencias, límites y entorno; revisar, aprobar y versionar una configuración.
Estados y recuperación: Configuración pendiente o inválida bloquea uso productivo; cambios futuros no reescriben acuerdos fijados.
RF asociados: RF-049, RF-061, RF-067, RF-073, RF-074.
# P 048 Validación automática de identidad
Actores y alcance: Profesional y administración · V2. Evaluar una integración futura de identidad.
Datos y acciones: Proveedor, consentimiento, evidencia requerida y resultado; enviar, revisar o apelar según política futura.
Estados y recuperación: Pendiente, rechazo o revisión manual; no mostrar distintivo antes de recibir evidencia válida.
RF asociados: RF-064.
# P 049 Captura para reconstrucción automática
Actores y alcance: Cliente · V2. Evaluar reconstrucción avanzada del espacio con captura compatible.
Datos y acciones: Fotos superpuestas o escaneo guiado, calidad y medidas de referencia; capturar, revisar y corregir.
Estados y recuperación: Dispositivo incompatible o reconstrucción incompleta; ofrecer expediente y esquema básicos sin bloquear cotizar.
RF asociados: RF-069.
# P 050 Sincronización de inventario
Actores y alcance: Proveedor y administración · V2. Conectar disponibilidad a una fuente externa validada.
Datos y acciones: Sistema origen, mapeo de referencias y actualización; conectar, revisar discrepancias o volver a modo manual.
Estados y recuperación: Sincronización fallida o dato desactualizado; no afirmar existencia física sin confirmación.
RF asociados: RF-070.
# P 051 Facturación electrónica
Actores y alcance: Destinatarios y administración · V2. Evaluar emisión fiscal con una integración habilitada.
Datos y acciones: Datos de facturación, documentos, importes y estado del operador; solicitar y consultar comprobante.
Estados y recuperación: Pendiente, rechazado o corregido; un recibo de demo no equivale a factura electrónica válida.
RF asociados: RF-071.
# Matriz de trazabilidad
Cada RF V1 tiene al menos una pantalla que muestra su efecto o permite la acción. Los RF de sistema pueden ejecutarse en segundo plano; la pantalla muestra el estado verificable. Las filas V2 son propuestas de navegación futura.

# Recorridos principales
Cliente: registro y perfil → proyecto y superficies → autorización y fotos revisadas → dossier y materiales → publicación → comparación → acuerdo → pago de prueba → seguimiento y cierre.
Contratista: perfil → proyectos → dossier → catálogo autorizado → propuesta → negociación → acuerdo → seguimiento → doble confirmación → liquidación.
Proveedor: perfil y catálogo → autorización de tarifas → solicitud de materiales → confirmación y entrega → recepción → liquidación de materiales.
Visita: búsqueda y perfil → solicitud → acuerdo y dirección autorizada → pago de prueba → cumplimiento → cierre o reclamación.
Reclamación: incidencia → evidencia y plazos → revisión administrativa → resolución registrada; fecha vencida nunca libera por sí sola.
| RF | Pantallas | Alcance |
| --- | --- | --- |
| RF-001 | P-002 | V1 |
| RF-002 | P-001 | V1 |
| RF-003 | P-003 | V1 |
| RF-004 | P-005 | V1 |
| RF-005 | P-006 | V1 |
| RF-006 | P-007, P-025 | V1 |
| RF-007 | P-005, P-006, P-008, P-015 | V1 |
| RF-008 | P-011, P-044 | V1 |
| RF-009 | P-004, P-008, P-016 | V1 |
| RF-010 | P-009 | V1 |
| RF-011 | P-009, P-010 | V1 |
| RF-012 | P-010, P-011 | V1 |
| RF-013 | P-012 | V1 |
| RF-014 | P-012 | V1 |
| RF-015 | P-010, P-012, P-013, P-015 | V1 |
| RF-016 | P-013, P-018 | V1 |
| RF-017 | P-004, P-007, P-023 | V1 |
| RF-018 | P-014, P-024 | V1 |
| RF-019 | P-023, P-024, P-026, P-028, P-036 | V1 |
| RF-020 | P-023, P-024, P-030, P-036, P-043 | V1 |
| RF-021 | P-025 | V1 |
| RF-022 | P-007, P-023, P-024 | V1 |
| RF-023 | P-004, P-017, P-018 | V1 |
| RF-024 | P-006, P-019 | V1 |
| RF-025 | P-006, P-019, P-020, P-021 | V1 |
| RF-026 | P-021, P-022 | V1 |
| RF-027 | P-021 | V1 |
| RF-028 | P-021, P-039 | V1 |
| RF-029 | P-018, P-027 | V1 |
| RF-030 | P-027, P-028, P-029 | V1 |
| RF-031 | P-014, P-018, P-027, P-029 | V1 |
| RF-032 | P-020, P-030 | V1 |
| RF-033 | P-022, P-028, P-031 | V1 |
| RF-034 | P-015, P-016 | V1 |
| RF-035 | P-004, P-016, P-029 | V1 |
| RF-036 | P-028, P-031 | V1 |
| RF-037 | P-031, P-032 | V1 |
| RF-038 | P-022, P-028, P-031, P-032, P-038 | V1 |
| RF-039 | P-031, P-032, P-034 | V1 |
| RF-040 | P-034 | V1 |
| RF-041 | P-016, P-034, P-035, P-043 | V1 |
| RF-042 | P-035, P-043 | V1 |
| RF-043 | P-034, P-040, P-041 | V1 |
| RF-044 | P-004, P-032, P-033, P-038 | V1 |
| RF-045 | P-036 | V1 |
| RF-046 | P-036, P-037 | V1 |
| RF-047 | P-037 | V1 |
| RF-048 | P-037, P-038 | V1 |
| RF-049 | P-027, P-028, P-038, P-047 | V1 |
| RF-050 | P-028, P-034, P-038 | V1 |
| RF-051 | P-022, P-032, P-033, P-038 | V1 |
| RF-052 | P-039 | V1 |
| RF-053 | P-039 | V1 |
| RF-054 | P-033, P-038, P-046 | V1 |
| RF-055 | P-022, P-032, P-033, P-038 | V1 |
| RF-056 | P-034, P-042 | V1 |
| RF-057 | P-037, P-040 | V1 |
| RF-058 | P-039, P-041, P-046 | V1 |
| RF-059 | P-045 | V1 |
| RF-060 | P-041, P-046 | V1 |
| RF-061 | P-047 | V1 |
| RF-062 | P-025 | V1 |
| RF-063 | P-045 | V1 |
| RF-064 | P-048 | V2 |
| RF-065 | P-023, P-026, P-036 | V1 |
| RF-066 | P-009, P-013, P-014, P-018, P-024 | V1 |
| RF-067 | P-011, P-015, P-044, P-047 | V1 |
| RF-068 | P-004, P-016, P-035, P-043 | V1 |
| RF-069 | P-049 | V2 |
| RF-070 | P-050 | V2 |
| RF-071 | P-051 | V2 |
| RF-072 | P-044 | V1 |
| RF-073 | P-025, P-028, P-029, P-031, P-032, P-036, P-037, P-038, P-047 | V1 |
| RF-074 | P-001, P-002, P-005, P-006, P-007, P-010, P-012, P-013, P-015, P-017, P-021, P-023, P-025, P-026, P-028, P-030, P-036, P-037, P-038, P-040, P-041, P-043, P-044, P-045, P-046, P-047 | V1 |