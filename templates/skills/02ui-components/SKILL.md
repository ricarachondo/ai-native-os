---
name: 02ui-components
description: Reglas de decisión, comportamiento y accesibilidad de ~25 componentes UI estándar (button, link, menu, text field, textarea, select, combobox, checkbox, radio group, switch, date picker, tabs, accordion, card, table, pagination, modal, drawer, popover, tooltip, toast, banner, badge/tag, loading/skeleton, empty state), destiladas de 02ui.com. USAR cuando se construya, audite, groomee o especifique UI en cualquier proyecto — dispara con "qué componente usar", "es este el componente correcto", "audit de UI", "accesibilidad de un componente", "cuándo usar X vs Y", o al nombrar cualquiera de los componentes de la lista. Cubre reglas de comportamiento/estructura/accesibilidad — NO identidad visual (eso lo define el design system propio de cada proyecto). Para dimensiones/spacing/breakpoints ver la skill hermana `responsive-flow`.
---

# 02ui-components — reglas de uso de componentes UI

Destilado de [02ui.com](https://02ui.com/components/), un catálogo de ~25 componentes UI
"escrito para la decisión, no para la API": cada componente responde primero
*¿es este el correcto, o el de al lado calza mejor?* antes de entrar en anatomía o
markup. Esta skill lo convierte en referencia rápida para trabajo de diseño,
grooming y auditoría de UI.

## Qué es esto / qué no es

- **Es**: reglas de *cuándo usar cada componente*, *comportamiento esperado*,
  *estructura*, *accesibilidad* (roles ARIA, teclado, foco, contraste) y
  *errores comunes* — conocimiento transversal a cualquier stack o librería de
  componentes.
- **No es**: un design system visual. No define color, tipografía, radios,
  espaciado en valores concretos, ni ninguna decisión de identidad de marca.
  Eso lo define el design system propio de cada proyecto.

## Jerarquía frente al design system del proyecto

El design system visual del proyecto manda en tokens, color y tipografía.
Estas reglas mandan en decisión de componente, comportamiento, estructura y
accesibilidad. Ante un choque **visual** (ej. qué tan redondeado es un botón,
qué paleta usa un badge de error), gana el design system del proyecto. Ante un
choque de **comportamiento, estructura o accesibilidad** (ej. si algo debe ser
un modal o un drawer, si un menu necesita `role="menu"`, cuál es el touch
target mínimo), ganan estas reglas — no son negociables por preferencia
estética.

## Cómo navegar esta skill

Este SKILL.md es el índice de decisión — cubre el 80% de los casos con la
tabla de abajo. El destilado completo de cada componente (variantes, estados,
copy, casos borde, markup de accesibilidad) vive en
`components/{slug}.md`, uno por componente, cada uno con su URL fuente en la
primera línea para re-consultar cuando el sitio cambie. Lee el archivo
individual cuando la tabla de abajo no basta para decidir, o cuando hace falta
el detalle de implementación (ARIA, teclado, copy).

Skill hermana: **`responsive-flow`** — cómo estos mismos componentes se
adaptan entre desktop/tablet/mobile, breakpoints, touch targets, y el 8-point
grid system de spacing/dimensiones. Esta skill no repite esas reglas.

## Índice-decisión

Una línea por componente: cuándo usarlo, y a qué componente saltar cuando NO
es el correcto.

| Componente | Úsalo cuando | NO lo uses cuando (usa esto) |
|---|---|---|
| **Button** | algo ocurre y la persona se queda en la página | el clic navega (**Link**); revela una lista de acciones (**Menu**) |
| **Link** | el clic navega a otra página/sitio/ancla, o descarga algo | nada carga, solo ocurre una acción (**Button**) |
| **Menu** | lista corta (<10) de acciones tras un trigger, elegir ejecuta de inmediato | la elección fija un valor que se guarda/envía (**Select**); la lista es larga y necesita buscarse (**Combobox**) |
| **Text field** | texto libre de una línea, corto e impredecible | corre a varias líneas (**Textarea**); es un set pequeño y conocido de opciones (**Select**/**Radio group**) |
| **Textarea** | texto libre multi-línea, largo impredecible, saltos de línea con significado | cabe en una línea (**Text field**) |
| **Select** | lista oculta de ~5-15 opciones conocidas, elegir exactamente una | 2-4 opciones que caben en pantalla (**Radio group**); >15-20 opciones (**Combobox**) |
| **Combobox** | lista larga (>15-20) donde escribir un fragmento es más rápido que escanear | la lista es corta y se escanea en segundos (**Select**) |
| **Checkbox** | elegir cualquier número de opciones (incluida ninguna); el cambio espera guardado/submit | el cambio aplica de inmediato sin guardado (**Switch**); debe elegirse exactamente una (**Radio group**) |
| **Radio group** | ~2-7 opciones visibles a la vez, elegir exactamente una, comparar lado a lado ayuda | más de ~7 opciones o sin espacio (**Select**); puede ser verdadera más de una (**Checkbox**) |
| **Switch** | el cambio aplica ahora mismo, sin guardado; exactamente dos estados, setting independiente | el cambio espera un guardar/enviar (**Checkbox**); son 3+ opciones (**Radio group**/**Select**) |
| **Date picker** | ver el calendario (día de semana, rango, fechas bloqueadas) ayuda a elegir | la fecha es cercana o memorizada (**Text field** con hint de formato); son presets con nombre (**Select**) |
| **Tabs** | ~2-7 paneles "pares" entre los que se elige, un panel visible a la vez, cambio instantáneo | hay que comparar/escanear varias secciones en secuencia (**Accordion**); el panel merece URL/bookmark propio (**páginas separadas**) |
| **Accordion** | página larga, secciones de lectura opcional, cualquier número abierto a la vez | todos leen todas las secciones igual (**headings planos**); las secciones son alternativas excluyentes (**Tabs**) |
| **Card** | unidades de contenido repetidas en grid/lista que alguien compara de un vistazo | son filas del mismo atributo a comparar por columna (**Table**); un solo destino sin nada más que comparar (**Link** plano) |
| **Table** | comparar el mismo atributo entre registros, alinear valores en columna | un solo registro sin columna que escanear (**Card**); las filas son solo destinos (**lista de links**) |
| **Pagination** | lista larga y rankeada, alguien puede volver o compartir el link a una página | cabe en 1-2 pantallas (**scroll simple**); se busca un registro específico (**búsqueda/filtros**) |
| **Modal** | tarea corta y autocontenida que debe bloquear la página hasta terminar/cancelar | no hace falta bloquear (**Drawer**); es contenido chico anclado a un control (**Popover**); merece URL propia (**página**) |
| **Drawer** | comparar el contenido del panel contra la página de atrás importa; no necesita hard stop | la tarea necesita bloquear todo (**Modal**); es contenido chico ligado a un trigger puntual (**Popover**) |
| **Popover** | contenido flotante anclado con algo clickeable adentro (link, botón, campo) | el contenido es solo lectura (**Tooltip**); la tarea justifica bloquear la página (**Modal**); es una lista de acciones (**Menu**) |
| **Tooltip** | label corto no-interactivo que nombra o aclara algo, no requerido para la tarea | tiene algo clickeable adentro (**Popover**); el contenido es necesario para completar la tarea (**hint visible en la página**) |
| **Toast** | confirma algo que ya terminó, se retira solo, no necesita sobrevivir un reload | la condición sigue siendo cierta tras un reload (**Banner**); el error es de un campo específico (**inline error**) |
| **Banner** | condición persistente hasta que algo cambie, sobrevive reload, aplica a página/sección | se auto-descarta en segundos (**Toast**); es de un campo específico (**inline error**) |
| **Badge and tag** | estado corto seteado por el sistema (badge) o etiqueta aplicada por una persona y removible (tag), 1-2 palabras | clickearlo dispara una acción (**Button**); necesita una oración de explicación (**Banner**) |
| **Loading/skeleton** | espera notable (~1s+); shape conocido → skeleton, shape desconocido o control puntual → spinner | la respuesta suele resolver bajo 1s (**nada**); hay progreso real calculable (**progress bar** determinada) |
| **Empty state** | pantalla estable donde genuinamente no hay nada (first use / sin resultados / todo resuelto) | los datos fallaron al cargar (**mensaje de error con retry** — nunca empty state disfrazado); sigue cargando (**loading state**) |

## Grafo de componentes confundibles

Los pares/tríos que el sitio resuelve explícitamente como "comparación
directa", cada uno con un test de una frase para decidir rápido:

- **Checkbox vs Switch** — ¿el cambio aplica ahora o espera un guardar? Switch
  = ahora; Checkbox = espera. Test: tapa el botón guardar — si el setting
  sigue teniendo sentido, era switch.
- **Modal vs Drawer vs Page** — ¿cuánto de la interfaz se gana la tarea? Modal
  = bloquea todo (decisión corta autocontenida); Drawer = bloquea parcial
  (comparar con lo de atrás importa); Page = URL propia, contenido sustancial.
  Nunca anidar modal dentro de drawer ni viceversa.
- **Tooltip vs Popover** — ¿se puede clickear algo adentro? Si sí, popover.
  Tooltip nunca lleva links/botones (falla en touch, a veces en mouse).
- **Button vs Link** — ¿cambia la URL tras el clic? Test: clic derecho — si
  "abrir en nueva pestaña" funciona, es link, sin importar el markup.
- **Select vs Radio group vs Combobox** — conteo de opciones. ~2-5 visibles →
  radio group; ~5-15 ocultas → select; >15-20 con búsqueda → combobox.
- **Toast vs Banner vs Inline error** — ¿sobrevive un reload? ¿aplica a toda
  la pantalla o a un campo? Toast = no sobrevive, confirma algo terminado;
  Banner = sobrevive, condición de página/sección; Inline = pertenece a un
  campo exacto.
- **Tabs vs Accordion** — ¿alguien necesitaría leer dos secciones a la vez?
  Si sí, accordion (todas quedan en el flujo). Tabs ocultan el resto por
  completo — no sirven para comparar. En pantallas angostas el mismo
  contenido en accordion suele ganarle a tabs.
- **Skeleton vs Spinner** — ¿se conoce el layout de antemano? Skeleton
  dibuja la forma (esperas ~1-10s, layout predecible); Spinner solo
  comunica que algo pasa (esperas cortas/impredecibles, sin forma).

Pares adicionales que aparecen repetidos dentro de los componentes
individuales (menos centrales que los 8 de arriba, pero recurrentes en
auditoría):

- **Menu vs Select**: menu ejecuta una acción y se olvida; select guarda un
  valor que se reutiliza. Un menu usado para guardar país/plan/orden es un
  select disfrazado.
- **Card vs Table**: card compara unidades completas de un vistazo; table
  compara un atributo específico columna abajo. El mismo dataset puede pedir
  cualquiera de los dos según qué se está comparando.
- **Badge vs Tag vs Button**: ¿quién seteó el valor? Sistema y read-only →
  badge; persona y removible → tag; si clickearlo ejecuta algo → dejó de ser
  ninguno de los dos, es un button.
- **Popover vs Menu vs Drawer**: si el contenido flotante es solo una lista de
  acciones que se eligen y cierran, es menu disfrazado de popover; si necesita
  más espacio del que un anchor cómodo permite, es drawer disfrazado de
  popover.

## Reglas transversales

Patrones que se repiten en la mayoría de los 25 componentes — verificarlos es
más rentable que revisar cada componente por separado:

1. **Target size**: 24×24 CSS px es el mínimo legal (WCAG 2.5.8 AA) y aparece
   citado en 18 de los 25 componentes — es prácticamente universal. Para
   touch real, 44×44pt (Apple HIG / WCAG 2.5.5 AAA) es la recomendación
   práctica, no solo el mínimo legal. Detalle de breakpoints y touch targets
   en `responsive-flow`.
2. **Contraste**: 4.5:1 para texto (WCAG 1.4.3), 3:1 para bordes/iconos/
   elementos no-textuales que cargan significado (WCAG 1.4.11) — chequeado
   por separado en cada variante de color/severidad, no solo en el estado
   default.
3. **Nunca color como única señal** (WCAG 1.4.1): todo estado semántico
   (error, warning, seleccionado, activo) necesita una segunda señal —
   ícono, texto, posición, forma — no solo un cambio de color. Cubre a ~8%
   de hombres con daltonismo.
4. **Focus ring nunca se quita sin reemplazo** (WCAG 2.4.7): es el error de
   accesibilidad más citado en todo el catálogo. Un componente interactivo
   sin foco visible es invisible para navegación por teclado.
5. **Reconstruir con `<div>` pierde comportamiento nativo**: `role="button"`,
   `role="link"`, etc. sobre un div solo repone el nombre en el árbol de
   accesibilidad — no repone tab stop, teclado (Enter/Space/Tab), ni
   comportamientos del navegador (middle-click, historial, autofill,
   password managers). Preferir el elemento HTML nativo siempre que exista.
6. **Estados mínimos esperables** en cualquier componente interactivo:
   default, hover (nunca única señal — no existe en touch), focus,
   pressed/active, disabled, y loading/error cuando aplica. La ausencia de
   alguno de estos es el hallazgo de auditoría más común.
7. **`disabled` real vs `aria-disabled`**: el atributo `disabled` nativo saca
   el control del tab order y pierde la posibilidad de explicar por qué está
   apagado. Para casos donde la razón importa (formularios, tooltips en
   triggers deshabilitados), preferir un control focuseable con
   `aria-disabled="true"` que bloquea la acción en su handler.
8. **Anuncios sin robar foco**: cambios de estado que no inició directamente
   un submit (resultados de búsqueda, toasts, banners que aparecen solos)
   usan `aria-live`/`role="status"` (`polite`) o `role="alert"`
   (`assertive` solo para lo urgente) — nunca mueven el foco del usuario.
9. **RTL**: casi todos los componentes necesitan espejarse con propiedades
   lógicas (`padding-inline-start`, no `padding-left`) — chevrons,
   posición de iconos, alineación de paneles flotantes.
10. **`prefers-reduced-motion`**: toda animación (slide, fade, pulse, spin)
    necesita una versión atenuada o estática — citado en casi todos los
    overlays y estados de carga.
11. **Timing de Nielsen** (referencia recurrente): bajo 100ms se siente
    instantáneo (sin loading state); ~1s mantiene el flujo (loading state
    aparece tras ~200-300ms de delay para no parpadear en respuestas
    rápidas); 10s pierde la atención (necesita mensaje real, no solo un
    spinner corriendo).

## Casos de uso operativos

**Grooming de UI**: antes de especificar un issue que involucra un
componente, verificar contra el índice-decisión que el componente elegido es
el correcto para el caso — y si el issue menciona "modal" o "dropdown" de
forma genérica, confirmar cuál de las alternativas reales aplica (¿modal o
drawer? ¿select o combobox?) antes de que quede escrito en la spec.

**Auditoría/QA de superficies existentes**: recorrer una pantalla o flujo
contra la tabla de reglas transversales (estados mínimos presentes,
accesibilidad, foco) y contra el archivo del componente específico para su
lista de errores comunes — la sección "Errores comunes" de cada
`components/{slug}.md` es, en efecto, un checklist de auditoría ya escrito.

**Review de diseño**: al revisar una propuesta visual, separar dos preguntas
distintas — ¿el componente elegido es el correcto? (esta skill) y ¿respeta el
design system visual del proyecto? (skill del proyecto). Un componente puede
estar bien elegido y mal skinneado, o bien skinneado pero ser el componente
equivocado para el caso.

**Auditoría de un prototipo antes de portarlo a producción**: cuando se porta
un prototipo (de una herramienta de diseño, un mockup, u otro código) al
código real del proyecto, es el momento más barato para corregir elecciones
de componente equivocadas — pasar el prototipo por el índice-decisión y la
lista de errores comunes de cada componente involucrado antes de escribir el
código de producción, no después.

## Fuente y mantenimiento

Fuente: [02ui.com/components](https://02ui.com/components/), consultado
2026-08-05. Cada `components/{slug}.md` cita su URL exacta. Si el sitio
cambia de contenido o agrega componentes, re-consultar y actualizar el
archivo afectado — no todo el catálogo.
