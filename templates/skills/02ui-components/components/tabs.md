Fuente: https://02ui.com/components/tabs/ (consultado 2026-08-05)

# Tabs

Muestran paneles de contenido relacionado de a uno, cambiando al clickear un label en vez de cargar una página nueva. Todo vive en una sola página: nada para hacer bookmark o compartir por URL, salvo que se sincronice el estado manualmente.

## Cuándo usarlo / cuándo NO

Usar cuando:
- Los paneles son pares entre sí (Overview, Specs, Reviews de un mismo producto).
- Solo un panel necesita atención a la vez.
- Hay entre ~2 y 7 paneles, pocos para caber en una fila sin wrap.
- El cambio de panel debe sentirse instantáneo, sin reload.

Usar otra cosa cuando:
- Alguien debería poder hacer bookmark/compartir un link directo a un panel y las tabs no sincronizan estado con la URL — usar **páginas separadas**.
- Hay que comparar dos paneles a la vez o escanear varias secciones en secuencia — usar un **accordion**.
- Solo hay un panel — un solo tab es un label disfrazado de control; usar un **heading plano**.

## Distinción explícita: tabs vs. accordion

Tabs muestran un panel a la vez y ocultan el resto completamente — sirve para contenido entre el cual se **elige** (Overview vs. Specs). Accordion mantiene todas las secciones en el flujo de la página y permite abrir varias a la vez — sirve para contenido que se **escanea en secuencia** (un FAQ). En pantallas angostas, 3-4 tabs cuestan más taps para comparar que las mismas secciones apiladas como accordion — el accordion suele ganar en mobile.

## Variantes

- **Segmented**: triggers dentro de un track redondeado y relleno; el activo tiene su propio fondo. Lee como un solo control — para un set pequeño y fijo (view switcher).
- **Underline**: línea fina marca el trigger activo sobre fondo plano. Más liviano, para tira sobre área grande de contenido (settings page).
- **Con counts**: número junto al label cuando el tamaño importa antes de abrir ("Comments (12)").

## Estados

Active, Inactive (texto atenuado, sigue clickeable, nunca tan tenue que parezca disabled), Focus (anillo distinto del indicador activo — un tab puede tener foco sin estar activo al navegar con flechas), Disabled (opacidad reducida, no alcanzable por teclado, explicar por qué).

## Comportamiento

- Solo un panel se renderiza a la vez (los demás se desmontan u ocultan) — por eso son rápidos pero no sirven para comparar lado a lado.
- Selección inmediata, sin confirmación: click o Enter sobre un trigger muestra el panel ya.
- La tira no se reordena sola, ni siquiera por datos de uso — romper el orden espacial rompe la memoria del usuario recurrente.
- El contenido bajo la tira puede cambiar de altura entre tabs; si ese salto molesta, reservar una altura mínima.

## Accesibilidad

- Teclado: Tab entra a la tira (aterriza en el trigger activo) y sale al primer elemento focuseable del panel; flechas izq/der (o arriba/abajo si es vertical) mueven foco entre triggers; Home/End saltan al primero/último; Enter/Espacio activa el trigger enfocado.
- Patrón WAI-ARIA: `role="tablist"` en la tira, `role="tab"` con `aria-selected` en cada trigger, `role="tabpanel"` en el contenido, conectados con `aria-controls`/`aria-labelledby` coincidentes.
- Solo el tab activo está en el tab order normal; el resto se alcanza con flechas (patrón single-tab-stop, como un radio group).
- `aria-label` en el tablist para dar nombre accesible al grupo.
- Contraste 3:1 en el indicador activo (WCAG 1.4.11); target size mínimo 24×24 CSS px (WCAG 2.5.8).

## Copy

- Labels son sustantivos cortos: "Reviews", no "See what people are saying" — la tira se lee de un vistazo.
- Mantener labels de largo similar entre sí; uno muy largo rompe el ritmo del grupo.
- Ordenar por lo que la gente necesita primero (Overview antes de Specs antes de Reviews), no alfabético.

## Errores comunes

1. Campo requerido escondido en un tab no seleccionado — el formulario falla al enviar sin error visible.
2. Tabs usados para un flujo lineal paso a paso (checkout) — eso es trabajo de un **stepper**, no de tabs (implican que cualquiera puede abrirse en cualquier orden).
3. Más tabs de los que caben en una fila (>7) — agrupar el overflow en un select o side nav.
4. Sin sincronización de URL para contenido que vale compartir — un link copiado siempre aterriza en el primer tab.
5. Estado activo que es solo cambio de color — necesita una segunda señal (underline, fondo relleno) para baja visión/daltonismo.
6. Reordenar tabs según uso — rompe la memoria espacial de un visitante recurrente.

## Casos borde

- Panel sin contenido aún: mostrar un empty state real, no dejarlo en blanco.
- Deep linking: leer el tab activo desde query param o route segment al cargar, y escribirlo en cada cambio.
- Label muy largo: truncar con ellipsis, mantener el label completo en focus/hover.
- Tabs anidados (dos tiras, una controlando paneles de otra): raro, suele ser señal de que se necesita otra estructura (sidebar + tabs).

## Componentes relacionados

- **Accordion**: para contenido que se escanea en secuencia y puede tener varias secciones abiertas a la vez.
- **Card**: agrupa contenido relacionado en una unidad visible para comparar varias a la vez.
- **Menu**: lista de acciones revelada por un trigger.
