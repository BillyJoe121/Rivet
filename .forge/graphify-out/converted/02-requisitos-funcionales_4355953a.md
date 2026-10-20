<!-- converted from 02-requisitos-funcionales.docx -->

Rivet Requisitos funcionales
Propuesta de aplicación móvil Flutter
12 de octubre de 2026  |  Versión 1.0
# Propósito y alcance
Rivet es una aplicación académica para reducir la fricción al cotizar trabajos de pintura y estuco en una ciudad inicial de Colombia. Conecta clientes, contratistas y proveedores; un equipo administrador opera la plataforma. La cotización combina información del espacio, referencias de materiales y una propuesta profesional negociable.
La versión V1 incluye captura guiada con medidas ingresadas por las personas, un dossier paramétrico, catálogo autorizado por proveedores, cotizaciones, solicitud de visita y seguimiento de pagos simulado en el entorno académico. La ayuda de IA interpreta imágenes y señala supuestos: no certifica medidas, cantidades, calidad de obra, autenticidad de productos ni resultados de pago. El contratista valida y puede corregir las cantidades antes de fijar una cotización.
# Glosario
- Dossier: ficha de un proyecto con superficies, medidas aportadas por el cliente, fotografías publicadas minimizadas, esquema paramétrico y rango de materiales estimado.
- Superficie: pared, techo u otra zona incluida por el cliente con descripción, ancho y alto; el área calculada parte de esas medidas.
- Rango de materiales: cálculo indicativo que aplica rendimiento de ficha técnica, número de capas y supuestos declarados; no constituye garantía de compra suficiente.
- Proyecto abierto: solicitud pública por barrio o zona que permite recibir propuestas profesionales.
- Visita: servicio presencial solicitado y acordado por cliente y profesional, con precio y condiciones visibles antes de pagar.
- Cotización fijada: propuesta aceptada que deja registrado su alcance, desglose, precio, tarifas visibles y condiciones de ejecución.
- Saldo de mano de obra / saldo de materiales: componentes separados del dinero de una contratación; cada uno sigue su propio flujo de aprobación.
- Revisión: caso que detiene la liberación del saldo afectado cuando hay silencio, desacuerdo o reporte pendiente de resolución.
# Reglas comerciales y límites
- Publicar un proyecto, consultar proyectos y negociar cotizaciones es gratis para clientes, contratistas y proveedores. No se cobra por publicar, ver o intercambiar propuestas; V1 no exige suscripción.
- Antes de fijar una cotización y pagar contratación, el cliente ve cualquier tarifa de servicio aplicable, base y porcentaje. La tarifa de contratación cubre el servicio de Rivet, incluida la asistencia de IA. No hay cobro por negociar; los valores comerciales requieren decisión de producto (DEC-01).
- La comisión del profesional se calcula al desembolso sobre una base y porcentaje aún por decidir (DEC-02). La pantalla de demo identifica los valores como simulados.
- La comisión del proveedor será menor al 1%; la decisión sobre tasa, base, recargo o descuento sigue pendiente (DEC-03). No se calcula una tarifa comercial definitiva hasta resolverla.
- Una fecha pactada vencida no libera automáticamente el saldo de mano de obra. Se avisa a las partes; una prórroga requiere aceptación mutua. El silencio o desacuerdo crea una revisión con plazos por definir (DEC-04).
- El pago de materiales se acepta y libera por separado después de registrar entrega y aceptación; no espera a la terminación de la obra.
- En demostraciones académicas, los pagos y desembolsos son simulados. Una operación productiva requiere un operador de pagos, vinculación y contrato verificados, así como revisar si el producto de pagos soporta el flujo propuesto. La especificación no afirma que exista escrow legal ni que un desembolso condicionado esté garantizado.
- Una ficha de catálogo documenta lo que informó el proveedor y la ficha técnica referenciada. La publicación en Rivet no certifica origen, lote ni autenticidad del material.
- La dirección exacta solo se comparte con el profesional contratado según el flujo autorizado. En listados públicos se muestra barrio o zona, sin dirección exacta.
- El consentimiento para procesar imágenes es explícito. Se elimina EXIF antes de almacenar/publicar derivados; la foto original queda privada y la versión publicada se minimiza. Las zonas generadas por IA se señalan como generadas; la IA no inventa una pared oculta ni elimina defectos visibles.
# Épica 1 Acceso perfiles y privacidad
## RF 001 Crear cuenta y seleccionar rol
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Alta
La persona crea una cuenta y selecciona el rol con el que usará la aplicación. El rol no concede por sí mismo permisos administrativos.
- Aceptación: Al completar los campos requeridos, la aplicación registra la cuenta con el rol elegido y presenta su inicio correspondiente.
## RF 002 Iniciar sesión
- Actor: Cliente, contratista, proveedor o administrador | Versión: V1 | Prioridad: Alta
La persona accede a su cuenta mediante el mecanismo de autenticación configurado para la demo.
- Aceptación: Con credenciales válidas se abre el espacio asociado a la cuenta; con credenciales inválidas se muestra un error y se conserva la pantalla de acceso.
## RF 003 Recuperar acceso
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Media
La persona solicita recuperar el acceso usando el canal registrado por el prototipo.
- Aceptación: La aplicación confirma que recibió la solicitud sin revelar si un correo o teléfono pertenece a otra cuenta.
## RF 004 Completar perfil de cliente
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente agrega nombre visible y datos de contacto necesarios para gestionar sus proyectos.
- Aceptación: El perfil muestra los campos guardados y permite editarlos sin modificar el historial de cotizaciones.
## RF 005 Completar perfil profesional
- Actor: Contratista | Versión: V1 | Prioridad: Alta
El contratista describe experiencia, servicios de pintura o estuco, portafolio fotográfico y zona de atención; cualquier distintivo de verificación se muestra solo si existe evidencia registrada.
- Aceptación: Al guardar, su tarjeta presenta la información ingresada y no presenta una insignia no sustentada.
## RF 006 Vincular proveedor y autorizar catálogo
- Actor: Proveedor | Versión: V1 | Prioridad: Alta
El proveedor registra su perfil comercial y autoriza qué referencias puede publicar, incluidos precios para cliente y contratista cuando estén disponibles.
- Aceptación: Un producto solo aparece como referencia autorizada después de guardar proveedor, alcance de autorización y fecha de vigencia.
## RF 007 Configurar zona pública
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
La persona indica barrio o zona para mostrar en solicitudes y búsquedas; la dirección exacta se captura en el flujo privado correspondiente.
- Aceptación: Un proyecto visible públicamente muestra barrio o zona y la vista pública no contiene la dirección exacta.
## RF 008 Administrar consentimiento de datos e imágenes
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente acepta de forma explícita el uso de fotos del proyecto para generar ayudas visuales y elige si permite publicar versiones minimizadas.
- Aceptación: Sin consentimiento para procesamiento no se inicia la interpretación; la interfaz registra la opción elegida antes de cargar las fotos.
# Épica 2 Proyecto captura y dossier
## RF 009 Crear proyecto de pintura o estuco
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente inicia un proyecto de pintura o estuco e indica nombre, tipo de trabajo, ciudad habilitada y zona pública.
- Aceptación: El cliente puede seleccionar pintura o estuco; el proyecto guardado aparece en su lista con estado “Borrador” hasta que lo publique.
## RF 010 Registrar superficie y medidas
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente agrega cada superficie con descripción, ancho y alto en unidades visibles; el área se calcula desde esos datos y se puede corregir.
- Aceptación: Al guardar una superficie, se muestran descripción, dimensiones, unidad y área calculada; una medida inválida produce un mensaje junto al campo.
## RF 011 Adjuntar fotos por superficie
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente adjunta una o más fotos a la superficie correspondiente y puede describir condiciones relevantes observadas.
- Aceptación: Cada foto queda asociada a una superficie, muestra su estado de carga y puede retirarse antes de solicitar interpretación.
## RF 012 Revisar alcance de autorización antes de procesar
- Actor: Cliente | Versión: V1 | Prioridad: Alta
Antes de procesar imágenes, la aplicación explica que la IA puede ayudar a identificar elementos visibles y producir una imagen derivada, y que no garantiza mediciones ni cantidades.
- Aceptación: El procesamiento comienza únicamente después de una confirmación explícita del cliente.
## RF 013 Solicitar ocultamiento de pertenencias
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente solicita ocultar pertenencias visibles para preparar una versión publicable de la foto.
- Aceptación: La solicitud genera un estado “En revisión” y conserva disponible la imagen original privada.
## RF 014 Revisar imágenes transformadas
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente compara original privado y derivado antes de publicarlo; la interfaz identifica las áreas generadas y permite rechazar el resultado.
- Aceptación: La imagen derivada no se publica hasta que el cliente la aprueba; si la rechaza, queda fuera del dossier público.
## RF 015 Mantener original privado y derivado publicado
- Actor: Cliente | Versión: V1 | Prioridad: Alta
La aplicación conserva original y derivado como recursos distintos, elimina metadatos EXIF de las copias procesadas y publica solo el derivado aprobado y minimizado.
- Aceptación: En la vista pública solo se puede abrir el derivado aprobado; la vista pública no expone el archivo original ni sus metadatos EXIF.
## RF 016 Consultar y editar esquema 3D paramétrico
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
El dossier presenta un esquema 3D paramétrico editable basado en superficies y medidas ingresadas y elementos conocidos. No inventa superficies ocultas; la estimación de materiales se muestra por separado en RF-066.
- Aceptación: El cliente edita datos propios; el contratista propone una copia corregida con autor identificado, sin modificar la captura del cliente.
# Épica 3 Catálogo de materiales
## RF 017 Consultar catálogo autorizado
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
La persona consulta productos publicados por proveedores que autorizaron su referencia para Rivet.
- Aceptación: Cada resultado identifica nombre, proveedor y estado de disponibilidad; un producto no autorizado no aparece como oferta vigente.
## RF 018 Ver ficha técnica y rendimiento
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
La persona abre la ficha de producto con presentación, volumen o contenido, color, acabado, rendimiento declarado, capas y vínculo a la fuente técnica.
- Aceptación: Una referencia sin rendimiento o fuente registrada se marca como “Dato pendiente” y no alimenta un cálculo presentado como basado en ficha.
## RF 019 Ver precios y vigencia
- Actor: Cliente o contratista autorizado por proveedor | Versión: V1 | Prioridad: Alta
La persona consulta precio según audiencia autorizada, presentación y fecha de vigencia registrada por el proveedor.
- Aceptación: Al vencer la vigencia, el precio se marca “Por confirmar” y no se reutiliza como precio confirmado en una nueva cotización.
## RF 020 Confirmar disponibilidad con proveedor
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Media
El cliente o contratista solicita confirmar disponibilidad para una referencia; el proveedor registra respuesta y fecha.
- Aceptación: La referencia cambia a “Confirmada” o “No disponible” con marca de fecha; sin respuesta permanece “Por confirmar”.
## RF 021 Administrar referencias de proveedor
- Actor: Proveedor | Versión: V1 | Prioridad: Alta
El proveedor crea, actualiza o desactiva referencias con SKU, presentación, volumen, color, acabado, precio por audiencia autorizada y vigencia.
- Aceptación: Al guardar se valida que los campos obligatorios estén completos y la referencia muestra la fecha de última actualización.
## RF 022 Consultar procedencia y respaldo de materiales
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Media
La ficha identifica proveedor, referencia, fuente técnica y respaldo aportado; distingue información declarada de evidencia revisada. La publicación no certifica por sí sola la autenticidad del producto físico.
- Aceptación: La nota se muestra en ficha y cotización junto al producto, antes de que el cliente lo incluya en una contratación.
# Épica 4 Exploración y visitas
## RF 023 Explorar proyectos abiertos por zona
- Actor: Contratista | Versión: V1 | Prioridad: Alta
El contratista filtra proyectos abiertos por ciudad, barrio o zona y tipo de trabajo.
- Aceptación: Cada tarjeta pública muestra resumen y zona; no contiene dirección exacta ni datos privados del cliente.
## RF 024 Buscar y consultar profesionales
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente busca profesionales por servicio y zona en tarjetas o lista, y consulta servicios, portafolio, experiencia declarada y reseñas vinculadas disponibles de un profesional.
- Aceptación: La tarjeta separa datos declarados de reseñas registradas y no muestra atributos no aportados o verificados.
## RF 025 Solicitar visita
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente solicita una visita a un profesional seleccionado, indica disponibilidad y recibe una propuesta de valor y condiciones de la visita.
- Aceptación: La solicitud queda “Pendiente de acuerdo” hasta que ambas partes acepten fecha, alcance y precio.
## RF 026 Acordar y pagar visita
- Actor: Cliente y contratista | Versión: V1 | Prioridad: Alta
Ambas partes confirman valor, fecha y condiciones antes de registrar el pago de la visita; en la demo el pago es simulado.
- Aceptación: Solo tras ambas confirmaciones la visita pasa a “Acordada” y muestra el estado de pago como “Simulado” en el entorno académico.
## RF 027 Compartir dirección exacta al profesional contratado
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente proporciona la dirección exacta para coordinar una visita o una contratación aceptada, dentro de un acceso privado ligado a esa relación.
- Aceptación: La dirección no aparece en resultados públicos y solo se muestra al profesional relacionado con la visita o contratación activa.
## RF 028 Cancelar o reprogramar visita
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Media
Una de las partes solicita cancelar o cambiar la fecha y la otra responde; la aplicación registra el acuerdo y deja condiciones económicas pendientes de política cuando aplique (DEC-05).
- Aceptación: La visita cambia de estado solo después de registrar la respuesta requerida y ambas partes pueden consultar el historial de cambios.
# Épica 5 Cotización y negociación
## RF 029 Preparar propuesta profesional
- Actor: Contratista | Versión: V1 | Prioridad: Alta
El contratista crea una propuesta para un proyecto con alcance, superficies incluidas, exclusiones, duración estimada y fecha de vigencia.
- Aceptación: La propuesta incompleta no puede enviarse; una propuesta enviada aparece al cliente con su alcance y estado.
## RF 030 Desglosar mano de obra y materiales
- Actor: Contratista | Versión: V1 | Prioridad: Alta
El contratista presenta por separado mano de obra, materiales, presentaciones, cantidades, precios y totales, y puede identificar ítems por confirmar.
- Aceptación: El total coincide con la suma visible de componentes y los ítems no confirmados se etiquetan antes de enviar la propuesta.
## RF 031 Corregir cantidades del dossier
- Actor: Contratista | Versión: V1 | Prioridad: Alta
El contratista revisa las cantidades del dossier, ingresa una corrección y registra motivo o supuesto usado.
- Aceptación: La cotización muestra cantidad original, cantidad corregida y nota profesional, conservando trazabilidad de ambas.
## RF 032 Negociar alcance y precio
- Actor: Cliente y contratista | Versión: V1 | Prioridad: Alta
Las partes intercambian contrapropuestas de alcance y precio con historial; la negociación no genera suscripción ni cobro por cada mensaje.
- Aceptación: Cada contrapropuesta muestra autor, fecha y versión; solo una versión expresamente aceptada puede fijarse.
## RF 033 Ver tarifa del cliente antes de fijar
- Actor: Cliente | Versión: V1 | Prioridad: Alta
Antes de fijar una cotización, el cliente ve la tarifa de contratación, su base, porcentaje o regla aplicable y el total que se cobraría; negociar propuestas no tiene cobro. Si un parámetro sigue pendiente, la demo lo marca como supuesto y no lo presenta como valor aprobado.
- Aceptación: La acción de fijar no está disponible hasta que el cliente vea el desglose de tarifa; el sistema conserva la versión mostrada y no aplica cargos por intercambiar propuestas (DEC-01).
## RF 034 Publicar proyecto sin costo
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente publica un proyecto abierto después de completar los datos mínimos y revisar qué contenido será visible por zona.
- Aceptación: La confirmación de publicación informa que publicar es gratis y la solicitud aparece en búsqueda sin dirección exacta.
## RF 035 Consultar y comparar cotizaciones
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente compara propuestas por alcance, fecha, precios separados, vigencia, disponibilidad de materiales y tarifa de Rivet.
- Aceptación: La comparación presenta los mismos campos para cada propuesta y destaca los datos que siguen sin confirmar.
## RF 036 Fijar cotización aceptada
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente acepta una versión de propuesta; la aplicación guarda un resumen congelado con alcance, componentes, tarifas mostradas, supuestos y fecha.
- Aceptación: Después de fijar, ambas partes pueden abrir el mismo resumen; cualquier cambio posterior requiere una nueva versión y aceptación.
# Épica 6 Contratación y seguimiento financiero
## RF 037 Formalizar contratación
- Actor: Cliente y contratista | Versión: V1 | Prioridad: Alta
El cliente solicita formalizar la cotización fijada y el contratista confirma; el resumen identifica que los términos de pago de la demo son simulados.
- Aceptación: La contratación queda pendiente de pago al confirmar ambas partes el resumen; solo pasa a ejecución cuando el pago se confirma conforme a RF-055 y conserva la cotización aceptada.
## RF 038 Consultar tarifa de servicio del cliente
- Actor: Cliente | Versión: V1 | Prioridad: Alta
El cliente consulta la tarifa que corresponde a la cotización aceptada, incluyendo estado “por definir” cuando el parámetro comercial no se haya aprobado.
- Aceptación: El historial muestra la tarifa efectivamente presentada al fijar y no sustituye silenciosamente el valor por un parámetro posterior.
## RF 039 Retener saldo total de mano de obra hasta aprobación final
- Actor: Cliente y contratista | Versión: V1 | Prioridad: Alta
La contratación registra el saldo total de mano de obra como retenido hasta que ambas partes aprueben el cumplimiento final. Los anticipos o desembolsos por hitos son una posible evolución V2, no una condición V1.
- Aceptación: El resumen muestra el saldo total retenido y no ofrece liberaciones parciales por hitos en V1.
## RF 040 Aprobar cumplimiento de mano de obra
- Actor: Cliente y contratista | Versión: V1 | Prioridad: Alta
Para el cierre de mano de obra, cada parte registra su aprobación de cumplimiento; solo las dos aprobaciones habilitan la solicitud de liberar el saldo retenido.
- Aceptación: Con una aprobación o ninguna, el saldo permanece retenido; con dos, aparece “Aprobado por ambas partes” y la acción de liberación se habilita según el entorno.
## RF 041 Gestionar vencimiento de fecha pactada
- Actor: Cliente, contratista y administrador | Versión: V1 | Prioridad: Alta
Al pasar la fecha pactada sin cierre aprobado, la aplicación alerta a las partes y mantiene retenido el saldo de mano de obra afectado.
- Aceptación: Al vencer la fecha, se registra la alerta y el saldo continúa sin liberar automáticamente.
## RF 042 Solicitar prórroga por ambas partes
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
Una parte propone una fecha nueva y la otra acepta o rechaza; una fecha modificada requiere aprobación de ambas.
- Aceptación: La fecha vigente solo cambia tras ambas respuestas afirmativas y el historial conserva la fecha anterior y el autor de la propuesta.
## RF 043 Retener revisión ante silencio o desacuerdo
- Actor: Cliente, contratista y administrador | Versión: V1 | Prioridad: Alta
Si una parte no responde dentro del plazo configurado o reporta desacuerdo, se crea una revisión y se detiene la liberación del saldo afectado; los plazos son parámetros pendientes (DEC-04).
- Aceptación: La revisión muestra motivo, partes, plazo configurado y estado; mientras esté abierta, ninguna acción automática libera el saldo discutido.
## RF 044 Consultar historial financiero y estado de pago
- Actor: Cliente, contratista, proveedor o administrador | Versión: V1 | Prioridad: Alta
La persona autorizada consulta cargos, pagos, reembolsos, comisiones, intentos y estados, diferenciando transacción simulada de confirmación de pasarela.
- Aceptación: Cada evento muestra monto, concepto, fecha, identificador de referencia y estado; un estado simulado no se presenta como dinero recibido.
# Épica 7 Materiales entrega y comisiones
## RF 045 Solicitar materiales por cotización
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
La parte responsable crea una solicitud desde las líneas de materiales de la cotización e indica cantidades, presentación y proveedor seleccionado.
- Aceptación: La solicitud registra cada ítem y distingue disponibilidad confirmada de disponibilidad pendiente.
## RF 046 Coordinar entrega de materiales
- Actor: Proveedor, cliente y contratista | Versión: V1 | Prioridad: Media
Las partes registran fecha prevista, lugar compartido de forma privada y estado de despacho para los materiales solicitados.
- Aceptación: El detalle de la solicitud presenta último estado, autor y fecha; la dirección no aparece en la vista pública.
## RF 047 Confirmar recepción y aceptación de materiales
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
El destinatario registra cantidades recibidas y acepta o reporta faltantes o daños con descripción y evidencia opcional.
- Aceptación: La aceptación cierra la recepción; un faltante o daño deja el ítem en revisión y conserva el detalle reportado.
## RF 048 Liberar pago de materiales por separado
- Actor: Cliente y proveedor | Versión: V1 | Prioridad: Alta
El pago de materiales se gestiona como componente separado y puede pasar a liberación tras aceptación de la entrega según el flujo habilitado.
- Aceptación: El estado del pago de materiales cambia por su propia aceptación y no depende del estado final de la mano de obra.
## RF 049 Registrar comisión profesional pendiente
- Actor: Administrador | Versión: V1 | Prioridad: Media
La aplicación registra la comisión aplicable al profesional en el evento de desembolso, con base y porcentaje marcados “Pendiente de decisión” hasta aprobación comercial (DEC-02).
- Aceptación: La demo permite ver el cálculo simulado y sus parámetros; no registra una comisión productiva mientras estén pendientes.
## RF 050 Calcular liquidación profesional al desembolso
- Actor: Administrador | Versión: V1 | Prioridad: Alta
Al simular un desembolso, la aplicación desglosa monto bruto, comisión profesional y neto usando parámetros configurados y muestra que la operación no es una dispersión real.
- Aceptación: El desglose permite recalcular con los valores visibles y cada cifra queda asociada a la versión del parámetro aplicada.
## RF 051 Evitar cobros o desembolsos duplicados
- Actor: Cliente, contratista y administrador | Versión: V1 | Prioridad: Alta
La aplicación registra cada intento financiero con referencia única y permite consultar su resultado antes de crear otro intento para la misma obligación.
- Aceptación: Repetir una confirmación o reintentar una solicitud con la misma referencia no crea un segundo cargo o desembolso en el historial de demo.
# Épica 8 Cancelaciones conciliación reseñas y casos
## RF 052 Cancelar contratación
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
Una parte solicita cancelar una contratación e informa motivo; la aplicación conserva el saldo involucrado y deriva la solicitud a la política de cancelación aún por definir (DEC-05).
- Aceptación: La cancelación solicitada no borra contrato, pagos ni historial y su estado muestra quién debe responder.
## RF 053 Solicitar reembolso
- Actor: Cliente o administrador | Versión: V1 | Prioridad: Alta
La persona solicita reembolso de un pago y relaciona el motivo con el evento original; aprobación, tiempos y casos parciales quedan sujetos a decisión comercial (DEC-06).
- Aceptación: La solicitud enlaza el pago original, monto y estado; no cambia a “Reembolsado” hasta registrar confirmación del operador o estado simulado explícito.
## RF 054 Conciliar pagos con pasarela
- Actor: Administrador | Versión: V1 | Prioridad: Alta
El administrador compara eventos internos con la referencia y estado informados por la pasarela configurada, o carga un resultado simulado en la demo.
- Aceptación: Una discrepancia queda en estado “Por conciliar” con referencias visibles; el sistema no marca como conciliado un evento sin correspondencia.
## RF 055 Confirmar pago con resultado de pasarela
- Actor: Sistema y administrador | Versión: V1 | Prioridad: Alta
La aplicación actualiza el estado del pago a partir de una respuesta verificable del operador o de un evento simulado claramente etiquetado; los estados técnicos y reintentos se ajustarán al proveedor elegido (DEC-07).
- Aceptación: Un retorno visual de éxito sin evento de confirmación no modifica el pago a “Confirmado”; la demo muestra el origen de la confirmación.
## RF 056 Calificar transacción completada
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Media
Las partes pueden dejar una reseña vinculada a una contratación con estado completado; la reseña no es requisito para aprobar cumplimiento ni liberar dinero.
- Aceptación: La reseña muestra la contratación asociada y la opción de publicar, y el flujo de aprobación funciona aunque no se escriba una reseña.
## RF 057 Reportar incidencia o incumplimiento
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Alta
Una parte reporta una incidencia, selecciona categoría, agrega descripción y adjunta evidencia opcional.
- Aceptación: El reporte recibe identificador, fecha y estado “Abierto”, y queda visible solo para sus participantes autorizados y administración.
## RF 058 Consultar resolución y plazos de disputa
- Actor: Cliente, contratista, proveedor o administrador | Versión: V1 | Prioridad: Alta
Las partes consultan mensajes, solicitudes de evidencia, resolución y fechas de respuesta configuradas para su caso.
- Aceptación: Cada cambio de estado y fecha queda en el historial; un plazo no configurado se indica como pendiente y no se inventa.
# Épica 9 Administración y evolución
## RF 059 Administrar usuarios y reportes
- Actor: Administrador | Versión: V1 | Prioridad: Alta
El administrador consulta cuentas, proyectos, catálogos, transacciones y reportes para atender incidencias dentro del alcance autorizado.
- Aceptación: Cada resultado muestra estado y referencia; las acciones disponibles dependen del rol administrador configurado.
## RF 060 Resolver casos con trazabilidad
- Actor: Administrador | Versión: V1 | Prioridad: Alta
El administrador solicita información, registra una decisión y actualiza el estado de un caso sin alterar eventos financieros previos.
- Aceptación: La resolución muestra responsable, motivo, fecha, evidencia consultada y saldo relacionado; el historial anterior permanece consultable.
## RF 061 Configurar tarifas y plazos con auditoría
- Actor: Administrador | Versión: V1 | Prioridad: Alta
El administrador autorizado mantiene parámetros de tarifas, vigencias y plazos una vez aprobados por producto; cada cambio registra autor, valor anterior, nuevo valor, motivo y fecha.
- Aceptación: La pantalla de auditoría permite consultar todos esos campos y las cotizaciones fijadas conservan la versión de parámetro que se les mostró.
## RF 062 Administrar disponibilidad de catálogo
- Actor: Proveedor y administrador | Versión: V1 | Prioridad: Media
El proveedor actualiza disponibilidad de sus productos y el administrador revisa cambios reportados; disponibilidad no confirmada se muestra como pendiente.
- Aceptación: Una nueva solicitud de materiales presenta el último estado y su fecha, y permite pedir confirmación cuando haya vencido.
## RF 063 Consultar actividad operativa
- Actor: Administrador | Versión: V1 | Prioridad: Baja
El administrador consulta conteos de proyectos, cotizaciones, solicitudes de visita y casos según datos registrados, indicando periodo y filtros.
- Aceptación: Cada conteo se puede rastrear a registros del periodo y la vista no incorpora cifras de mercado ni afirmaciones externas no sustentadas.
## RF 064 Verificar identidad de profesional automáticamente
- Actor: Contratista y administrador | Versión: V2 | Prioridad: Media
La plataforma podrá integrar un proceso automatizado de validación de identidad del profesional, sujeto a proveedor, autorización, tratamiento de datos y revisión legal por definir.
- Aceptación: Solo se mostraría un estado de verificación tras recibir y registrar el resultado del proveedor; la función no forma parte del alcance V1.
## RF 065 Autorizar manualmente al contratista para precio profesional
- Actor: Proveedor | Versión: V1 | Prioridad: Media
El proveedor autoriza o revoca a contratistas individuales para consultar su precio profesional, manteniendo separado el precio público para clientes.
- Aceptación: Una cuenta de contratista sin autorización solo ve precio de cliente; al autorizarla, ve el precio profesional vigente y la fecha de autorización.
## RF 066 Estimar rango de materiales con trazabilidad
- Actor: Cliente o contratista | Versión: V1 | Prioridad: Alta
La aplicación calcula un rango indicativo desde las áreas ingresadas, producto y rendimiento de ficha, capas y supuestos visibles; el contratista puede corregir valores dejando motivo. El cálculo no garantiza cantidades suficientes.
- Aceptación: El resultado permite abrir cada dato usado, ver fuente, capas, supuestos y correcciones; si falta ficha o rendimiento, el sistema marca la estimación como incompleta.
## RF 067 Consultar límites y costo máximo de asistencia de IA
- Actor: Cliente | Versión: V1 | Prioridad: Alta
Antes de solicitar procesamiento, el cliente consulta límites de uso y costo máximo aplicable a la asistencia de IA, que está cubierto por la tarifa de contratación del servicio; la negociación de propuestas no genera cobro.
- Aceptación: La pantalla presenta límites y costo máximo configurados antes de procesar; si falta un parámetro aprobado, lo identifica como pendiente y no añade un cobro por solicitud o negociación.
## RF 068 Recibir notificaciones de eventos
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Media
La persona recibe avisos dentro de la aplicación sobre nuevas propuestas, estados de pago, vencimientos de fechas pactadas y solicitudes o respuestas de prórroga.
- Aceptación: Cada aviso enlaza al evento relacionado, indica fecha y puede marcarse leído; al abrirlo, el estado del evento coincide con su detalle.
## RF 069 Reconstruir automáticamente modelo 3D
- Actor: Cliente | Versión: V2 | Prioridad: Baja
La plataforma podrá generar un modelo 3D automático a partir de captura compatible, pendiente de evaluar precisión, dispositivos, privacidad y costos.
- Aceptación: La función permanece fuera de V1 y solo podrá liberar un modelo V2 con origen de captura y estado de revisión visibles.
## RF 070 Sincronizar inventario de proveedor
- Actor: Proveedor y sistema | Versión: V2 | Prioridad: Baja
La plataforma podrá sincronizar existencias con sistemas de inventario de proveedores mediante integraciones por definir.
- Aceptación: La función no forma parte de V1; en V2 cada dato sincronizado mostraría fuente y fecha de última actualización.
## RF 071 Emitir facturación electrónica
- Actor: Cliente, contratista, proveedor y administrador | Versión: V2 | Prioridad: Baja
La plataforma podrá integrar la generación o consulta de facturación electrónica, sujeta a alcance fiscal, operador y responsabilidades por definir.
- Aceptación: La función no forma parte de V1 y no se presenta como servicio fiscal disponible hasta contar con integración y validación aplicables.
## RF 072 Solicitar eliminación de cuenta y contenido
- Actor: Cliente, contratista o proveedor | Versión: V1 | Prioridad: Alta
La persona solicita eliminar su cuenta y contenido asociado; la aplicación registra la solicitud y aplica la política aprobada de conservación de registros obligatorios, aún por definir (DEC-08).
- Aceptación: La persona puede consultar estado y alcance de su solicitud; los elementos cuya retención sea obligatoria se identifican como pendientes de eliminación sin prometer un plazo no aprobado.
# Requisitos complementarios de liquidación y acceso
## RF 073 Calcular y presentar comisión de materiales
- Actor: Cliente, proveedor, contratista y administrador | Versión: V1 | Prioridad: Alta
El sistema calcula la comisión de materiales con tasa, base y modalidad configuradas; diferencia recargo al comprador de deducción al proveedor y presenta precio final, comisión y neto del proveedor. La tasa comercial debe ser menor al 1% y permanece pendiente de aprobación según DEC-03.
- Aceptación: Los valores visibles permiten recomponer bruto y neto sin cobrar la comisión dos veces; una configuración pendiente solo produce ejemplos identificados como simulados y bloquea una operación real.
## RF 074 Autorizar acceso a datos y acciones de cada participante
- Actor: Sistema y administrador | Versión: V1 | Prioridad: Alta
El sistema verifica rol, propiedad y relación con proyecto, proveedor o caso antes de entregar archivos privados, tarifas profesionales y operaciones financieras. El acceso administrativo requiere permisos específicos y deja trazabilidad; una URL o cambio de rol en la interfaz no concede autorización.
- Aceptación: Un usuario ajeno no puede consultar originales, dirección, tarifas reservadas o casos privados mediante enlaces directos, ni aprobar o liberar saldos de otra contratación; el intento se rechaza sin exponer esos datos.
# Estados funcionales principales
- Proyecto: Borrador → Publicado → En negociación → Contratado → En ejecución → Completado. Puede pasar a Cancelación solicitada o Cancelado conforme a decisión pendiente; los cambios guardan autor y fecha.
- Cotización: Borrador → Enviada → En negociación → Aceptada y fijada, Rechazada o Vencida. Una modificación crea versión nueva.
- Visita: Solicitada → Pendiente de acuerdo → Acordada → Realizada; también puede quedar Cancelación solicitada, Cancelada o Reprogramación solicitada.
- Mano de obra total: Retenida → Aprobación final de una parte → Aprobada por ambas partes → Liberación solicitada → Simulado como liberada. La fecha vencida genera un aviso y no libera por sí sola; silencio o desacuerdo según el plazo configurado abre revisión.
- Materiales: Solicitados → Disponibilidad por confirmar / Confirmada → En entrega → Recibidos → Aceptados → Pago simulado liberado; daños o faltantes abren revisión del ítem.
- Pago o reembolso: Pendiente → En proceso → Confirmado / Rechazado / Por conciliar. El estado “Simulado” se identifica por separado y no equivale a movimiento real de dinero.
- Caso: Abierto → Espera de información → En revisión → Resuelto o Cerrado. Los plazos provienen de parámetros aprobados; un valor pendiente no activa temporizadores inventados.
# Decisiones pendientes de producto no aprobadas
- DEC-01 — Tarifa al cliente: definir base, porcentaje o monto, impuestos aplicables, momento exacto de cobro y tratamiento de cancelaciones.
- DEC-02 — Comisión profesional: definir porcentaje o regla, base del cálculo, responsable del pago, impuestos y relación con el desembolso.
- DEC-03 — Comisión al proveedor: definir tasa menor a 1%, base, quién la asume y si existe recargo o descuento; hasta decidir no fijar valores.
- DEC-04 — Incumplimiento y revisión: definir plazo de respuesta, alertas, evidencias aceptables, responsables, tiempos de resolución y efecto sobre cada saldo.
- DEC-05 — Visitas y cancelaciones: definir cancelación, reprogramación, cargos, devolución y tratamiento de contrataciones canceladas antes o después de iniciar.
- DEC-06 — Reembolsos: definir quién decide, reembolso total o parcial, plazos, costos de pasarela, disputas y forma de reflejar el resultado.
- DEC-07 — Operación de pagos: seleccionar operador y producto contractual; confirmar elegibilidad, verificación de comercio, recaudo, pagos a terceros, eventos de confirmación, conciliación, tiempos, retenciones y soporte de liberación condicionada. No llamar escrow al flujo sin validación legal y contractual.
- DEC-08 — Datos, imágenes y eliminación: definir retención, borrado, control de acceso, proveedores de IA, transferencias, registros obligatorios y texto final de autorización/aviso de privacidad.
- DEC-09 — Ubicación y lanzamiento: elegir ciudad inicial, zonas operativas, reglas de cobertura y momento para revelar la dirección exacta.
- DEC-10 — Cálculo técnico: acordar unidades, capas predeterminadas, redondeo por presentación, desperdicio, superficies descontables y comportamiento cuando falte ficha técnica.
- DEC-11 — Prueba de entrega: decidir evidencias, ventana de aceptación y tratamiento de recepción parcial de materiales.
- DEC-12 — Reseñas y moderación: definir elegibilidad, contenido permitido, derecho de respuesta, moderación y apelación.
# Fuera de alcance V1 V2
V1 no incluye anticipos ni desembolsos de mano de obra por hitos, reconstrucción automática del inmueble a partir de fotos, recomendador automatizado de productos o profesionales, sincronización de inventario en tiempo real, logística compleja de entregas, facturación electrónica, cobertura en varias ciudades, verificación automática de identidad ni manejo de dinero real condicionado. El saldo completo de mano de obra se conserva hasta aprobación final mutua. El esquema 3D es paramétrico y depende de datos ingresados y revisados por personas.
V2 podrá estudiar reconstrucción 3D automática con COLMAP o captura guiada con RoomPlan en dispositivos compatibles, sincronización de inventario, facturación electrónica y anticipos de mano de obra por hitos. Estas capacidades requieren definir y validar integraciones, precisión, privacidad, compatibilidad, costos y responsabilidades. COLMAP es un flujo de reconstrucción SfM/MVS desde imágenes; RoomPlan genera datos paramétricos de interiores con sensores compatibles. Ninguna referencia implica que Rivet ya implemente esas capacidades ni que sustituya la medición y validación profesional.
# Fuentes oficiales consultadas
- Pintuco, Viniltex Pro 650 — producto y ficha técnica descargable. Se citan como ejemplo de producto y fuente de atributos; cada catálogo debe conservar la ficha vigente que corresponda.
- Wompi, planes y tarifas Colombia, documentación para Colombia, activación de Pagos a Terceros y reglamentos. Las tarifas y requisitos visibles pueden cambiar y dependen del producto, plan y contrato; deben volver a verificarse antes de una integración comercial.
- COLMAP, tutorial oficial del proyecto, referencia de pipeline SfM/MVS para evaluar una posible ruta V2.
- Apple, RoomPlan — documentación oficial, referencia de captura de interiores para dispositivos y sensores compatibles.