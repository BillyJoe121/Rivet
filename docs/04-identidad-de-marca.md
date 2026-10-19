# Rivet — propuesta de identidad de marca

**Versión:** 12 de octubre de 2026 · **Estado:** dirección visual preliminar para prototipo académico.

> Rivet es un nombre provisional de trabajo. No se ha comprobado disponibilidad de dominio, razón social o marca registrada. Esta guía no es una identidad implementada ni una certificación de accesibilidad.

## 1. Posicionamiento, públicos y promesa

**Posicionamiento propuesto:** herramienta de cotización para trabajos de pintura y estuco que organiza fotos, medidas, materiales y mano de obra para que las personas puedan revisar y comparar el alcance antes de contratar.

**Públicos V1:**

- **Cliente:** quiere explicar un trabajo sin dominar unidades, rendimientos ni nombres comerciales; necesita ver el total y qué incluye cada oferta.
- **Contratista:** necesita recibir información útil, corregir cantidades, especificar materiales y separar su labor del costo de insumos.
- **Proveedor:** necesita publicar un catálogo claro y administrar tarifas diferenciadas para cliente y contratista.

**Promesa de marca:** “Conecta tu obra con una cotización mejor definida.” Describe el propósito del flujo, no garantiza precio, precisión técnica, disponibilidad o resultado del trabajo. El cliente, el profesional y el proveedor siguen teniendo que confirmar sus datos y acuerdos.

## 2. Nombre y uso

**Rivet** es una palabra inglesa que significa “remache”: una pieza que une componentes. El nombre representa el papel de la plataforma al conectar clientes, contratistas y proveedores alrededor de una misma cotización. Se escribe con R mayúscula y el resto en minúsculas. Pronunciación aproximada en español: *rí-vit*.

Usar el nombre con un descriptor mientras se valida el alcance: **Rivet · cotizaciones para tu obra**. En el proyecto académico, identificarlo como “nombre provisional”. Evitar “la marca líder”, “la app oficial”, “profesionales certificados” o cualquier lectura de disponibilidad registral, aval o certificación.

## 3. Voz y ejemplos funcionales

La voz es práctica, respetuosa y específica. Habla en español de Colombia, trata de “tú” de forma consistente y explica qué falta para avanzar. Prefiere “medidas por confirmar” a “medición inteligente garantizada”; “rango de materiales” a “precio exacto”; y “revisar oferta” a “elegir al mejor”. No culpa a la persona cuando una foto no sirve ni presenta a la IA como autoridad.

| Situación | Ejemplo de texto |
|---|---|
| Inicio de solicitud | “Agrega una pared o espacio. Indica ancho y alto en metros; podrás revisar las medidas antes de pedir cotizaciones.” |
| Estimación orientativa | “Rango estimado de materiales. Se calcula con tus medidas y la cobertura indicada en la ficha. Confirma las cantidades con el contratista.” |
| Revisión de foto con IA | “Revisa la versión antes de compartirla. Las zonas ocultas o generadas están marcadas. Tu foto original se mantiene privada.” |
| Error al leer una medida | “No pudimos interpretar esta medida. Escríbela o vuelve a tomar la foto; no ajustamos cantidades automáticamente.” |
| Tarjeta de profesional | “Disponibilidad por confirmar.” La persona acuerda fecha y visita directamente antes de contratar. |
| Tarifa de gestión | “Tarifa de gestión: COP [importe]. La pagas al aceptar esta contratación. Revisa qué cubre y las reglas de cancelación.” |
| Cargo por mano de obra | “Comisión del contratista: [tasa y base aprobadas]. Se descuenta al desembolso de mano de obra.” Si la tasa/base no están definidas, no mostrar un valor ficticio. |
| Materiales | “Comisión de materiales: [menor al 1%, por definir]. Aquí verás si se descuenta o se suma y quién la paga antes de confirmar.” Sustituir corchetes solo tras aprobación. |
| Visita pagada | “La visita cuesta COP [importe acordado]. Confirma con el profesional qué incluye y si se descuenta del trabajo si lo contratas.” |
| Fecha de trabajo vencida | “La fecha acordada ya pasó. No se realizará un pago automático. Confirma el cierre, acuerda una prórroga o solicita revisión.” |
| Pago en demostración académica | “Fondos pendientes de aprobación.” Es una etiqueta de estado simulada; no afirma custodia o pago real. |
| Reclamación | “Cuéntanos qué ocurrió y adjunta la información del proyecto. La solicitud queda pendiente de revisión; te informaremos el plazo cuando esté definido.” |
| Sin profesionales aún | “Todavía no hay ofertas para este trabajo. Puedes revisar las medidas o esperar nuevas respuestas.” |

No usar “pago seguro”, “dinero garantizado”, “escrow”, “resultado garantizado” o “material original verificado” sin una operación y evidencia que respalden específicamente esos términos.

## 4. Paleta y tipografía

La paleta busca asociar la marca con una superficie de trabajo tranquila y con planos medidos: verde profundo para lectura y estructura; papel cálido para fondos; arcilla para el acento; amarillo claro para información que requiere atención. Los nombres son tokens de diseño, no colores implementados.

| Token | HEX propuesto | Uso |
|---|---|---|
| `ink-900` | `#182D33` | Texto principal e iconos sobre fondos claros. |
| `ink-700` | `#495B61` | Texto secundario sobre fondos claros. |
| `paper-100` | `#F6F4EF` | Fondo general. |
| `surface-0` | `#FFFFFF` | Tarjetas, hojas de cotización y diálogos. |
| `brand-700` | `#164B42` | Color de marca para iconos, estructura y texto sobre fondos claros. |
| `leaf-300` | `#D9E3DE` | Superficie suave y áreas decorativas; no usar sola como texto. |
| `clay-600` | `#B65D25` | Acento y acción; comprobar el componente final además del par de color. |
| `sun-300` | `#F0C76A` | Atención no crítica, hitos y marcadores; no usar como texto sobre blanco. |
| `line-300` | `#D5D8D0` | Líneas divisorias y bordes, junto con etiquetas o iconos. |
| `success-700` | `#28664C` | Estado completado con texto, icono y etiqueta. |
| `warning-800` | `#795100` | Estado pendiente de atención con texto e icono. |
| `danger-700` | `#A33A32` | Error o acción destructiva; siempre acompañado de mensaje. |

Los cálculos entregados para estos pares de color usan la fórmula WCAG sobre valores sRGB. Son comprobaciones numéricas de colores, no una certificación de accesibilidad de la interfaz completa:

| Par de color | Contraste calculado |
|---|---:|
| Blanco `#FFFFFF` / verde de marca `#164B42` | 9,91:1 |
| Blanco `#FFFFFF` / terracota `#B65D25` | 4,58:1 |
| Texto `#182D33` / fondo `#F6F4EF` | 13,07:1 |
| Texto secundario `#495B61` / fondo `#F6F4EF` | 6,47:1 |
| Verde de marca `#164B42` / verde pálido `#D9E3DE` | 7,55:1 |

El equipo debe comprobar el componente final, tamaño, peso, borde, foco y estados, además del color. `leaf-300`, `sun-300` y `line-300` son superficies o señales; no sustituyen texto, borde identificable ni icono.

**Tipografía:** Inter o Noto Sans para la aplicación; ambas son familias abiertas, pero la licencia de la versión elegida debe verificarse antes de distribuir. Para documentos académicos se recomienda Aptos o Calibri por disponibilidad en procesadores comunes. Evitar combinar más de dos familias.

## 5. Tokens de interfaz y significado

Escala de espaciado: `4, 8, 12, 16, 24, 32, 48 px`. Radio: `6 px` en campos y botones, `12 px` en tarjetas, `20 px` en modales grandes. Mantener una retícula de 8 px para composición y usar 4 px para ajustes pequeños. En Flutter, px representa aquí píxeles lógicos y no píxeles físicos del dispositivo. Estos son valores sugeridos para el prototipo, no mediciones del código actual.

| Token | Valor de referencia | Uso |
|---|---|---|
| `type-caption` | 12/16 px | Metadato secundario; evitar para datos esenciales. |
| `type-body` | 16/24 px | Descripciones, controles y texto principal. |
| `type-section` | 20/28 px | Título de sección o tarjeta principal. |
| `type-page` | 28/36 px | Encabezado de pantalla; reducir responsivamente si hace falta. |
| `control-min` | 48 × 48 px | Altura/ancho mínimo recomendado para controles táctiles. |
| `focus-outline` | 2 px `ink-900` + separación 2 px | Foco de teclado claramente visible sobre superficies claras; probar cada componente. |

Estados y dinero siempre deben combinar texto, icono o forma, y color: “Pendiente de confirmación”, “Revisión solicitada”, “Pagado” o “No se realizó el pago”. No depender de una marca verde sin palabra. No crear insignias “Pro”, corona o prioridad pagada: la propuesta elimina la suscripción y la preferencia de visibilidad por pago.

## 6. Concepto de logotipo y especificación

**Concepto:** un marco cuadrado de esquinas suaves que contiene dos ángulos internos desplazados, como líneas de cota y capas de superficie. Las capas evocan partidas de una cotización y pintura aplicada; los ángulos aluden a medir un espacio. Mantener una geometría simple para que el símbolo sobreviva en tamaños de icono.

No incluir tilde de verificación, sello, escudo, medalla, casa con techo genérico ni brocha literal. El símbolo no debe insinuar inspección aprobada, garantía del profesional, certificación de materiales, custodio fiduciario o validación automática de medidas.

- **Versión principal:** símbolo a la izquierda y palabra Rivet en Inter/Noto Sans Semibold; tinta `ink-900` y un plano `leaf-300` con detalle `clay-600`.
- **Versión monocroma:** símbolo y nombre Rivet en `ink-900` o blanco sobre fondo `brand-700`. Mantener el detalle de capas por diferencia de contorno o espacio, no por color solamente.
- **Versión de acento:** símbolo en `ink-900` con una sola lámina `leaf-300`; reservar el acento arcilla para piezas editoriales o estados activos.
- **Icono de app:** solo el marco y los ángulos de cota/capas dentro de un cuadrado redondeado de fondo `paper-100`; evitar texto en el icono. Los ángulos internos deben conservarse legibles en tamaños pequeños o simplificarse de forma coherente.

**Especificación propuesta:** zona de reserva de un módulo alrededor, donde un módulo equivale al grosor de una lámina del símbolo; ancho mínimo del conjunto principal: 120 px en pantalla y 28 mm en impresión. Símbolo solo: mínimo 24 px, condicionado a prueba de legibilidad. No estirar, inclinar, cambiar proporciones, aplicar sombra, poner sobre fotografía compleja ni usar el color de estado de una transacción como relleno permanente. Estos valores requieren prueba visual con el arte vectorial final.

## 7. Fotografía, privacidad y uso de imágenes

Las imágenes deben explicar el espacio y el trabajo. Priorizar pared completa, esquinas, superficie y referencias de escala sin hacer de una marca comercial el foco. Pedir al cliente encuadrar el área de trabajo y evitar rostros, documentos, pantallas, fotos familiares, objetos de valor, direcciones visibles y datos del edificio.

Una imagen procesada por IA no reemplaza el original en privado. El cliente revisa antes de compartir, confirma defectos existentes y puede descartar la edición. Señalar en la vista publicada las zonas ocultas o generadas; nunca borrar la indicación de intervención. Si la IA cambia una grieta, humedad, descascaramiento, desnivel u otro defecto visible, no publicar esa versión como si fuera la superficie real: volver al original o marcar la zona para revisión manual.

El producto debe explicar dónde se procesa la imagen, quién accede y cuánto se conserva antes de pedir la foto. La ubicación compartida debe limitarse a lo necesario para cotizar; la dirección exacta se solicita solo cuando el flujo la necesita y se muestra a los participantes autorizados. Estos son requisitos de diseño pendientes de implementación y revisión de privacidad.

## 8. Accesibilidad, uso incorrecto y límites

- Comprobar contraste de texto, controles, bordes y estados con combinaciones reales; incluir foco visible, navegación por teclado, etiquetas para lectores de pantalla, orden de lectura y tamaños táctiles cómodos.
- Expresar estado y error con palabra e icono además del color. No comunicar un precio, riesgo o vencimiento únicamente con una muestra cromática.
- Permitir zoom del texto, diseño adaptable y reducción de movimiento. Ninguna animación debe ser necesaria para descubrir la zona editada, la tarifa o el estado de pago.
- Escribir importes en pesos colombianos con separadores consistentes y subtotales identificables. Mantener la tarifa del cliente, comisiones y quién las asume visibles antes de la aceptación cuando estén definidas.
- No usar colores de éxito en perfiles para insinuar certificación. Una reseña describe la experiencia de un usuario; no es un sello de garantía.
- No reutilizar el original privado para promoción, catálogo o entrenamiento de IA sin un propósito explicado y una autorización independiente.
- No publicar información que permita ubicar la vivienda más allá de lo que el cliente haya aprobado para recibir una cotización.

La implementación deberá probarse con personas que usan lectores de pantalla, teclado, ampliación y diferentes niveles de visión del color. Esta propuesta enumera prácticas para evaluar; no afirma que la marca o la app cumplan por anticipado una norma.
