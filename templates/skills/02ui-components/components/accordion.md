Fuente: https://02ui.com/components/accordion/ (consultado 2026-08-05)

# Accordion

Colapsa cada sección detrás de su propio heading, para que una página larga pueda escanearse por los headings antes de leer nada. Las secciones se mantienen en el orden de la página — eso es lo que lo separa de tabs. Suele agregarse tarde, cuando una página creció y nadie quiere cortar nada; vale la pena cuando alguien busca una sola respuesta entre doce, cuesta un click por sección cuando de todos modos iban a leer todo.

## Cuándo usarlo / cuándo NO

Usar cuando:
- La página es lo bastante larga como para que escanear headings primero ahorre scroll real.
- Cada sección es lectura opcional (FAQ, ficha técnica, ajustes avanzados).
- Alguien podría querer dos o tres secciones abiertas a la vez.
- Las secciones pertenecen a una sola secuencia, no son alternativas.

Usar otra cosa cuando:
- Todos leen todas las secciones igual — colapsar agrega un click y no esconde nada que valga la pena. Usar **headings y secciones planas**.
- Las secciones son alternativas entre las que se elige de a una — usar **tabs**.
- Cada header es en realidad un link a otro lado, no un panel de esta página — usar un **menú de navegación**.
- El contenido oculto es una sola oración explicando un control vecino — usar un **tooltip** o hint inline.

## Variantes

- **Single**: abrir una sección cierra la que estaba abierta. Sirve cuando los paneles son altos y dos abiertos a la vez empujarían el resto de headings fuera de vista.
- **Multiple**: cualquier cantidad de secciones abiertas a la vez, cada una cierra solo cuando se reactiva su propio heading. Default más seguro para FAQ/ficha técnica — nunca le quita al lector algo que eligió abrir.
- **Con meta**: count, precio o estado al final del header, para que el estado cerrado también cargue un valor, no solo un label (settings, resúmenes de pedido).

## Estados

Collapsed, Expanded (indicador apunta hacia arriba, el fondo del header cambia — pero el cambio de fondo solo no basta, el indicador debe rotar de verdad), Hover (el área de hover debe calzar con el área de click, no solo el texto), Focus (anillo en el botón, no en el panel), Disabled (raro; si una sección no tiene contenido aún, mejor un panel abierto con empty state corto que un header que nadie puede presionar).

El indicador (chevron) ES el estado: apunta abajo cerrado, arriba abierto — anticipa qué pasará antes de comprometerse, y sigue funcionando para quien no ve el tinte de fondo.

## Comportamiento

- Abrir una sección empuja todo lo de abajo hacia abajo (el trade-off contra tabs); animación típica 150-250ms.
- Contenido cerrado permanece en el DOM (hidden, no removido) — por eso find-in-page, print y buscadores lo alcanzan; el contenido debe estar en el HTML, no cargarse recién al click.
- Todo el header row es el target (label + espacio + indicador), no solo el chevron (que solo mide 16px en una fila de 48px).
- Single vs. multiple es una decisión de contenido, no de estilo — depende de si dos paneles alguna vez valen la pena leerse juntos.

## Accesibilidad

- Envolver cada trigger en un heading real: `<h3><button>…</button></h3>` — el mayor ganador de accesibilidad acá; lectores de pantalla navegan páginas largas por heading, y un accordion armado con `<div>` desaparece de esa lista.
- Patrón WAI-ARIA: `aria-expanded` en el botón, `aria-controls` apuntando al panel.
- `role="region"` + `aria-labelledby` en el panel cuando el set es chico (en un FAQ largo, muchos panels = muchos landmarks, evitar el role ahí).
- Teclado: Tab mueve al siguiente trigger y luego al contenido focuseable del panel abierto; Enter/Espacio togglea; flechas arriba/abajo entre triggers (opcional según WAI-ARIA); Home/End (también opcional).
- Contraste 3:1 en el indicador (WCAG 1.4.11); target size mínimo 24×24 CSS px (WCAG 2.5.8) — se cumple solo con hacer clickeable todo el header row.
- Nunca comunicar el estado solo por color; el indicador rotando es la señal primaria.

## Copy

- Headings responden "¿mi respuesta está acá?" — "How long does delivery take?" gana sobre "Delivery"; el lector compara su pregunta contra las palabras del heading.
- Adelantar la parte que distingue: "After 30 days" / "Within 30 days" al frente, no enterrado a mitad de frase.
- Mantener headings de largo similar — uno de tres líneas junto a vecinos de una línea rompe el ritmo del escaneo.
- Evitar "click to expand" — el indicador ya lo dice; repetirlo en ocho filas cuesta ocho líneas de escaneo.

## Errores comunes

1. Colapsar contenido que todos necesitan leer (costos de envío, términos de cancelación, lo que la página existe para decir) — alarga el trabajo del lector.
2. `<div>` con click handler como trigger — inalcanzable por teclado, sin role, no anuncia nada. Usar `<button>` dentro de un heading, o `<summary>`.
3. Indicador que apunta igual en ambos estados (un "+" que nunca es "−").
4. Cerrar la sección que alguien sigue leyendo — pasa en modo single-open cuando el lector abre una segunda sección para comparar. Si comparar es plausible, permitir multiple.
5. Solo el chevron responde al click — la gente apunta al label, que es lo que lee.
6. Accordions dentro de accordions — dos niveles de colapso y el lector no puede distinguir "vacío" de "cerrado otra vez".
7. Sin forma de linkear a una sección abierta — los artículos de soporte se comparten como link a una respuesta puntual.

## Casos borde

- Deep linking: leer fragment/query param al cargar, abrir la sección correspondiente y hacerle scroll; escribirlo de vuelta al abrir.
- Find-in-page sobre texto colapsado: Chrome soporta `hidden="until-found"` (no universal aún, tratar como bonus).
- Panel que cambia de altura después de abrirse (imagen/embed que carga tarde) — reservar espacio con width/height.
- Impresión: los estilos de impresión deben forzar todos los paneles abiertos.
- Un solo ítem: es un disclosure simple, válido, no necesita navegación por flechas ni lógica single-open.

## Componentes relacionados

- **Tabs**: para paneles entre los que se elige, mostrando uno a la vez y ocultando el resto.
- **Card**: agrupa contenido en una unidad visible para comparar varias a la vez.
- **Menu**: lista de acciones revelada por un trigger.
