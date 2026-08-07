---
name: responsive-flow
description: Reglas de adaptación responsive entre desktop/tablet/mobile (qué colapsa, qué se convierte en qué, breakpoints observados, touch targets), el 8-point grid system de spacing/dimensiones, y patrones de layout de lectura/artículo y de embeds de video. USAR cuando se diseñe, construya o audite comportamiento responsive, mobile-first, breakpoints, touch targets, spacing/sizing, o layout de contenido largo (blog/artículo) en cualquier proyecto — dispara con "responsive", "mobile-first", "breakpoint", "touch target", "8pt grid", "spacing scale", "se ve bien en mobile". Complementa la skill hermana `02ui-components` (decisión de componente y accesibilidad; no dimensiones).
---

# responsive-flow — adaptación responsive, grid de 8pt y layout de lectura

Reglas agnósticas de cómo los componentes de UI y el contenido largo deberían
adaptarse entre tamaños de viewport, más la disciplina de dimensionamiento
(8-point grid system) que sostiene esa adaptación. Parte del insumo viene de
observar en vivo el comportamiento responsive real de las demos de
[02ui.com](https://02ui.com) (componentes funcionando, no screenshots) en tres
tamaños de referencia — desktop 1280×800, tablet 768×1024, mobile 375×812 —
más investigación pública estándar sobre el 8pt grid.

## Qué es esto / qué no es

- **Es**: reglas de qué cambia entre tamaños de viewport (qué colapsa, qué se
  apila, qué se convierte en otro patrón), breakpoints de referencia, touch
  targets mínimos, y la escala de spacing/dimensiones (8pt grid) que sostiene
  todo lo anterior.
- **No es**: un design system visual. No fija paleta, tipografía de marca, ni
  radios/sombras concretos — eso lo define el design system propio de cada
  proyecto. El design system visual del proyecto manda en tokens/color/
  tipografía; estas reglas mandan en comportamiento, estructura, dimensiones
  y accesibilidad ante resize. Ante choque visual gana el design system del
  proyecto; ante choque de comportamiento/estructura/dimensiones/a11y ganan
  estas reglas.

## Cómo navegar esta skill

Todo el contenido cabe en este único archivo (a diferencia de
`02ui-components`, que reparte el detalle en archivos por componente). Está
organizado en: el 8pt grid (spacing/sizing base), touch targets, breakpoints
observados, tabla de adaptación por componente, patrones de layout de
lectura/artículo, patrón de embeds de video, y cómo aplicar todo esto cuando
el proyecto es mobile-first.

## El 8-point grid system

Regla base: todo valor medible de layout — padding, margin, gap, alto de
componente, tamaño de ícono, border-radius — es múltiplo de 8. Escala típica:
**4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 80 · 96 · 128**. Usar la escala como
tokens de spacing, nunca valores ad-hoc elegidos "porque se ve bien ahí".

**Por qué 8, no otro número**: 8 divide limpio en las densidades de pantalla
habituales (1x, 1.5x, 2x, 3x) sin producir offsets de medio píxel — un valor
como 5px o 25px puede rendear borroso en un dispositivo a 1.5x mientras 8 y 24
escalan siempre a píxeles enteros. La segunda razón es de ritmo: una escala
única y compartida en toda la interfaz mantiene el ritmo vertical consistente
entre componentes distintos, construidos por personas distintas, en momentos
distintos. Adoptado como base de spacing en los design systems de Material
Design, Apple HIG y la mayoría de sistemas de producto grandes (Google, IBM,
Airbnb).

**Sub-grid de 4px**: válido como sub-unidad dentro del sistema de 8pt para
casos genuinamente chicos — el gap entre un ícono y su label, un ajuste de
line-height, elementos densos donde 8px es demasiado salto. Es la excepción
disciplinada, no una segunda base: si la mayoría de los valores de un
componente terminan siendo múltiplos de 4 y no de 8, probablemente el
componente está sub-dimensionado para el grid, no que el grid necesite
cambiar.

**Tipografía sobre el grid**: line-heights en múltiplos de 4 u 8 mantienen el
ritmo vertical del texto alineado con el resto del layout — un párrafo con
line-height de 22px rompe la alineación con cualquier elemento vecino
dimensionado en la escala de 8.

**Touch targets y el grid**: 44×44pt (iOS Human Interface Guidelines) y
48×48dp (Material Design) son los dos mínimos de industria — ver sección
siguiente. 48 cae limpio en la escala de 8; 44 es la excepción histórica de
Apple (no es múltiplo de 8, pero está cerca de 40/48 y ninguna de las dos
guías cede ante la otra).

**Errores comunes / cuándo romper la regla deliberadamente**: mezclar un
valor fuera de escala "porque se ve mejor ahí" sin criterio sistemático es el
error más común — rompe el ritmo del resto del layout de forma silenciosa. El
*spacing óptico* (ajuste visual deliberado — por ejemplo compensar el peso
visual de un ícono contra el de un texto vecino) es una excepción consciente
y documentada, no una licencia general: la regla es el default del sistema,
no un dogma que nunca se toca. La diferencia entre las dos es si alguien
puede explicar por qué se rompió, o si simplemente "quedó así".

Fuentes: [UXPin — UI Grids: The Complete Guide](https://www.uxpin.com/studio/blog/ui-grids-how-to-guide/),
[wpdean — What Is the 8-Point Grid System](https://wpdean.com/what-is-the-8-point-grid-system/),
[spec.fm — 8-Point Grid](https://spec.fm/specifics/8-pt-grid),
[GridMakerPro — 8pt grid, 12-column, baseline](https://gridmakerpro.com/learn/web-design-grid-systems-12-column-baseline-8pt/),
[Designary — Layout basics: grid systems and the 4px grid](https://blog.designary.com/p/layout-basics-grid-systems-and-the-4px-grid).

## Touch targets: el mínimo legal y el mínimo práctico

Dos números conviven en este territorio y no son intercambiables:

- **24×24 CSS px** — mínimo legal, WCAG 2.5.8 (AA). Es el número que aparece
  citado en 18 de los 25 componentes de `02ui-components` — el suelo debajo
  del cual un componente falla accesibilidad, sin importar el dispositivo.
- **44×44pt / 48×48dp** — mínimo *práctico* para touch real. iOS Human
  Interface Guidelines pide 44×44pt; Material Design pide 48×48dp. Ninguno de
  los dos es solo una sugerencia de industria — son los pisos que Apple y
  Google aplican a sus propios sistemas.

La distinción importa en auditoría: un componente puede pasar WCAG 2.5.8 (24×24)
y seguir siendo difícil de tocar en un dispositivo real. Para cualquier
superficie donde el input primario sea touch, tratar 44×44 como el target real
y 24×24 como el piso legal absoluto, no como el objetivo de diseño. Fuentes:
[Apple Human Interface Guidelines — layout](https://developer.apple.com/design/human-interface-guidelines/layout),
[TetraLogical — Foundations: target sizes](https://tetralogical.com/blog/2022/12/20/foundations-target-size/).

## Breakpoints observados

De la observación directa de demos reales y del texto normativo de un
catálogo de componentes UI (fuente: 02ui.com, tres tamaños de referencia
desktop 1280 / tablet 768 / mobile 375):

- **~480px**: umbral donde un control con label + ícono puede dejar caer el
  label y conservar solo el ícono (con el `aria-label` intacto) — observado
  empíricamente en un componente de paginación ("Previous"/"Next" pierden la
  palabra y quedan solo los chevrons justo antes de este ancho).
- **~768px**: umbral donde un layout de dos columnas (contenido + rail
  lateral) colapsa a una sola columna — inferido por observación transversal
  en varias páginas, no un único número citado textualmente.
- **~1024px** (`lg:` en convenciones de utility-CSS como Tailwind): umbral de
  colapso de navegación/rail lateral en layouts de contenido largo — inferido
  de clases de utilidad observadas, no verificado pixel a pixel contra el
  breakpoint exacto.
- **~240px de ancho de contenido** (no de viewport): tope de wrap para texto
  corto flotante (ej. un tooltip largo) — un límite de contenido, no de
  pantalla.

Ningún demo observado cambia de *layout* automáticamente vía JavaScript al
cruzar un breakpoint — toda la adaptación observada (overflow horizontal,
wrap, colapso de columna) viene de CSS/layout intrínseco, no de detección de
tamaño en runtime. Es una señal a favor de resolver responsive con CSS puro
(container queries, `overflow`, `flex-wrap`, `clamp`) antes de reachear a
JavaScript.

## Tabla de adaptación por componente

Qué se observó (o qué declara el propio texto normativo, cuando el demo en
vivo no lo implementaba) para 8 componentes especialmente sensibles a
viewport:

| Componente | Desktop/tablet | Mobile — "se convierte en / se comporta como" |
|---|---|---|
| **Tabs** | tira horizontal completa | igual, mientras entren ~2-4 labels cortos en una fila; pasado eso, scroll horizontal con affordance visible de que hay más, o cambiar a **select**/**accordion** — nunca wrap a dos filas |
| **Table** | todas las columnas visibles, sin scroll | scroll horizontal dentro de un contenedor con nombre y foco propio (`tabindex="0"`); alternativa: dropear columnas por prioridad + row expander, o migrar a lista de cards cuando comparar deja de ser el objetivo |
| **Modal** | tarjeta centrada flotante con backdrop | texto normativo pide expandir a **full screen** bajo un breakpoint, no encoger el layout de escritorio (un dialog de desktop deja casi sin margen en un teléfono) |
| **Drawer** | panel lateral de ancho fijo o ~50% en tablet | texto normativo: **bottom sheet** casi siempre gana sobre side drawer en mobile — gesto de swipe natural hacia abajo, dentro del alcance del pulgar, no recorre el ancho completo de la pantalla; side drawer se reserva para navegación con posición ya aprendida |
| **Menu** | fila normal, hover disponible | tap necesita el mismo hit target que un botón completo, mínimo 44×44pt — nunca una fila reducida pensada para mouse |
| **Pagination** | "Previous 1 2 3 4 … 16 Next" con palabras completas | solo chevrons "‹ 1 2 3 4 … 16 ›" bajo ~480px — la palabra se cae, el `aria-label` se conserva |
| **Date picker** | trigger + calendario en popover, o input nativo con spinners | el `<input type="date">` **nativo** ya cambia de patrón solo: el navegador entrega el date picker propio del sistema operativo en mobile (numérico con rueda), sin que el código tenga que hacer nada — una implementación custom que no replica esto pierde ese cambio gratis |
| **Tooltip** | aparece en hover/focus | **no existe hover en touch** — un tooltip que solo dispara por hover nunca aparece en un teléfono, o dispara con un long-press que casi nadie intenta; si la información importa en mobile, debe vivir en la página, no detrás de un tooltip |

Nota metodológica: en varios casos (Modal, Drawer, Tooltip) el **texto
normativo** de la fuente es más estricto que lo que sus propios demos en vivo
implementan — el demo de Modal, por ejemplo, no se expande a full-screen en
mobile pese a que el texto lo recomienda explícitamente. Tratar el texto
normativo como la regla a seguir, no el comportamiento del demo como
excusa para no implementarla.

## Patrones de layout de lectura / artículo (contenido largo)

Observado en el índice y el detalle de un blog de artículos largos (fuente
citada abajo) — patrones agnósticos de layout de lectura responsive,
aplicables a cualquier contenido tipo blog/artículo/documentación:

- **Measure fijo, no fluido**: la columna de texto mantiene un ancho CSS
  constante (~720px) tanto en desktop como en tablet — lo que cambia entre
  viewports es el *chrome* alrededor (aparece o desaparece un rail lateral),
  no el ancho de la columna de lectura. Es un patrón más robusto para
  legibilidad que escalar el ancho del texto junto con el viewport: el
  measure óptimo para lectura no depende del tamaño de pantalla, depende de
  caracteres por línea.
- **Tipografía por breakpoints discretos, no fluida**: el cuerpo de texto se
  mantiene a un tamaño y line-height fijos en los tres tamaños de viewport;
  solo el encabezado principal salta de tamaño, y lo hace en un único
  breakpoint discreto — no con `clamp()`/unidades `vw` escalando
  continuamente. El cuerpo se congela para preservar el ritmo vertical y el
  measure; solo los títulos, que son elementos aislados sin necesidad de
  alinearse línea a línea con nada, escalan.
- **Márgenes laterales como mecanismo responsive real**: en mobile, el
  contenido ocupa casi todo el ancho con padding lateral fijo, sin rail. En
  tamaños medianos/grandes aparece un rail angosto (breadcrumb/metadata). En
  desktop ancho, el espacio sobrante queda en blanco a la derecha — el
  contenido se mantiene alineado a la izquierda con su measure fijo, nunca
  centrado ni estirado a lo ancho completo.
- **Navegación colapsable que conserva la acción primaria**: el header pasa
  de una barra completa de enlaces a un menú hamburguesa, pero el call-to-
  action principal permanece visible incluso colapsado — colapsar navegación
  secundaria no debería esconder la acción que la página existe para que
  alguien tome.
- **Tabla de contenidos como acordeón universal, no sidebar condicional**: en
  vez de un patrón distinto por tamaño (sidebar sticky en desktop, acordeón
  en mobile), el mismo componente acordeón embebido en el flujo del artículo
  se usa en los tres tamaños — lo único exclusivo de desktop es un rail
  sticky angosto y separado, solo con el breadcrumb. Un único componente
  universal para la TOC es más simple de mantener que dos implementaciones
  responsive distintas para el mismo propósito.
- **Índice/listado (grid de artículos)**: layout tipo "hero + N columnas" en
  desktop colapsa a una sola columna en mobile/tablet; controles de filtro y
  búsqueda sobre el listado colapsan a una columna también, pero nunca se
  ocultan — filtrar y buscar siguen siendo posibles en cualquier tamaño.

Fuente: blog de un catálogo de componentes UI, [02ui.com/blog](https://02ui.com/blog/how-to-make-your-website-agentic-ready-in-2026/), consultado 2026-08-05.

## Patrón de embeds de video

Observado en el mismo artículo largo — un embed de video vertical integrado
en el flujo de lectura. Patrón técnico agnóstico, reutilizable en cualquier
proyecto que embeba video dentro de contenido largo:

- **Wrapper con `aspect-ratio` CSS** (la propiedad moderna, no el truco
  histórico de `padding-bottom` porcentual) reservando el espacio exacto
  *antes* de que el contenido cargue — layout shift cero (CLS de Core Web
  Vitals) sin costo de JavaScript. El elemento embebido (iframe o lo que sea)
  llena el 100% del wrapper por dentro; la proporción la sostiene el wrapper,
  no el contenido.
- **`loading="lazy"` nativo** en el elemento embebido evita que múltiples
  videos en una página larga compitan por ancho de banda en la carga
  inicial — es una línea de HTML, sin `IntersectionObserver` custom.
- **Dominio privacy-enhanced para embeds de terceros** (cuando el proveedor
  lo ofrece) reduce tracking antes de cualquier interacción del usuario —
  vale la pena preferirlo sobre el dominio de tracking completo por defecto
  cuando ambos existen.
- **Formato vertical (9:16) cuando el contenido es nativamente vertical**
  (reel/short de red social) en vez de forzarlo a 16:9: el wrapper limita el
  ancho máximo del embed a bastante menos que la columna de texto completa y
  lo centra — un patrón deliberado para insertar contenido vertical dentro de
  una columna de lectura horizontal, sin que domine el layout.
- **Nota de honestidad técnica**: el "facade pattern" (mostrar solo una
  miniatura estática y cargar el reproductor real recién al hacer click) es
  una técnica más agresiva de performance que también vale la pena conocer y
  evaluar caso a caso — pero no es lo que se observó en la muestra citada
  aquí, que usa un iframe presente desde el primer render con `lazy` nativo
  como única optimización. No asumir facade sin verificarlo en el proyecto
  fuente.

Fuente: mismo artículo citado arriba, [02ui.com/blog/how-to-make-your-website-agentic-ready-in-2026](https://02ui.com/blog/how-to-make-your-website-agentic-ready-in-2026/).

## Cómo aplicar esto cuando el proyecto es mobile-first

Cuando el grueso del tráfico esperado de un proyecto es móvil, estas reglas
se leen en el orden inverso al que suelen documentarse:

1. **Diseñar primero en el tamaño mobile de referencia del proyecto** (cada
   proyecto define el suyo — no hay un viewport "correcto" universal; esa
   decisión vive en la documentación del proyecto, no en esta skill) y
   verificar que escala hacia arriba, no al revés.
2. **Tratar 44×44 (o 48×48) como el target por defecto**, no como una
   excepción para "los botones importantes" — en un producto mobile-first
   casi todo lo interactivo es candidato a input táctil.
3. **Preferir los patrones que 02ui marca como ganadores en mobile** cuando
   haya ambigüedad de componente: bottom sheet sobre side drawer, accordion
   sobre tabs cuando el contenido lo permite, full-screen sobre modal
   flotante encogido, ocultar labels de texto pero conservar
   `aria-label` antes que recortar el control.
4. **Auditar tooltips agresivamente**: en un producto táctil, cualquier
   información detrás de un tooltip hover-only es información que una
   fracción relevante de usuarios nunca va a ver. Si la información importa,
   sacarla del tooltip y ponerla en la página.
5. **Usar el 8pt grid con más disciplina, no menos**: en pantallas chicas el
   espacio es más escaso y cada valor fuera de escala se nota más rápido —
   no es el lugar para "achicar todo un poco" fuera de la escala, es el
   lugar para usar los pasos más chicos de la misma escala (4, 8, 12) con
   más frecuencia.
6. **Medir el viewport de referencia del proyecto contra los breakpoints
   observados aquí** (~480, ~768, ~1024) para saber de qué lado de cada uno
   cae por defecto, y diseñar sabiendo si el comportamiento "mobile" de un
   componente es el default o la excepción para ese proyecto específico.

## Referencia cruzada

`02ui-components` cubre qué componente usar y sus reglas de accesibilidad
(incluido el mínimo legal de target size, 24×24). Esta skill cubre cómo ese
mismo componente se redimensiona y reordena entre viewports, y la disciplina
de spacing (8pt grid) que sostiene esas dimensiones. Para auditar un
componente completo, usar ambas: decisión + a11y desde `02ui-components`,
comportamiento responsive + dimensiones desde acá.
