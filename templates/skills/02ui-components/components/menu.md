Fuente: https://02ui.com/components/menu/ (consultado 2026-08-05)

## Qué es
Un menu es una lista de acciones revelada por un trigger (ej. los tres puntos de una fila de archivo). Elegir un ítem ejecuta esa acción de inmediato y cierra el menu — esa es la línea que separa un menu de un select. `<div role="menu">`, build difficulty: alto.

## Cuándo usarlo / Cuándo NO
Usar menu cuando: se necesitan varias acciones sin mostrarlas todas a la vez (Rename, Duplicate, Archive, Delete), el trigger es un botón/icono (no un campo que guarda un valor), elegir un ítem ejecuta la acción de inmediato, y la lista es corta (menos de ~10 ítems, legible de un vistazo).

Usar otra cosa cuando:
- La elección fija un valor que persiste y se envía (ej. status, país) → **Select**.
- Solo hay 2-3 acciones y hay espacio para mostrarlas sin ocultar nada → fila de **botones**.
- La lista es tan larga que se necesita buscar/filtrar → **Combobox**.
- Cada ítem lleva a una página/URL distinta → lista de **links**.

## Variantes
Con íconos + shortcuts (patrón de menú Edit de apps de escritorio — íconos y shortcuts consistentes, o ninguno de los dos), Con submenu (ítem que abre un segundo panel, marcado con chevron trailing propio; reservar para opciones genuinamente secundarias, no para esconder ítems que deberían estar en el nivel superior), Con checkbox items (toggle-style para view settings; sigue siendo una lista de acciones, no un valor a enviar).

## Estados
Closed, Open (panel cerca del trigger, primer ítem recibe foco; solo un menu abierto a la vez — abrir uno cierra el anterior), Item focused (fill de fondo, contraste 3:1 contra el panel — WCAG 1.4.11), Item disabled (opacidad reducida y NO focuseable — se salta con navegación por flechas, no solo se ve atenuado), Destructive (texto rojo, fill rojo al enfocarse, con un divider separándolo del resto).

## Comportamiento
Ejecuta una acción, no una selección persistente (si el ítem debe recordarse y reutilizarse en otro lado, es un select disfrazado). Solo un menu abierto a la vez. Se posiciona cerca del trigger y voltea (flip) cuando se queda sin espacio en el viewport. Elegir un ítem cierra el panel, excepto ítems tipo checkbox/radio (pueden quedar abiertos para marcar varios). Acciones destructivas necesitan divider y, si son irreversibles, un paso de confirmación aparte — el menu es el camino rápido a la acción, no el lugar para construir la confirmación.

## Accesibilidad
- Seguir el patrón WAI-ARIA menu: trigger con `aria-haspopup="menu"` y `aria-expanded`; panel con `role="menu"`; cada acción con `role="menuitem"`.
- El foco entra al panel al abrir (usualmente al primer ítem) y vuelve al trigger al cerrar.
- Ítems disabled llevan `aria-disabled="true"` y se saltan en la navegación por flechas, no solo se ven atenuados.
- Teclado: Enter/Space abre el menu o activa el ítem enfocado; flecha abajo/arriba mueve el foco (con wrap); flecha derecha abre submenu; flecha izquierda/Escape cierra submenu o el menu completo; escribir una letra salta al ítem que empieza con ella (type-ahead); Tab cierra el menu y mueve el foco al siguiente elemento de la página.
- Contraste: fill del ítem enfocado, 3:1 contra el fondo del panel (1.4.11).
- Target size: 24×24px CSS mínimo (2.5.8); en touch, mínimo 44×44pt real, no una fila reducida pensada para mouse.

## Copy
Ítems son verbos ("Duplicate", "Archive", "Delete"), no sustantivos ni frases. 1-3 palabras por ítem. Nombrar qué elimina una acción destructiva cuando hay espacio ("Delete project" mejor que "Delete"). Shortcuts según plataforma: ⌘ en macOS, Ctrl en Windows/Linux, mostrados exactamente como el OS los muestra.

## Errores comunes
1. Delete sin divider y sin color distintivo (un misclick entre "Rename" y "Delete" cuesta un archivo).
2. Un menu usado para guardar un valor (país, plan, orden) en vez de un select — se pierde el check mark del valor actual y la expectativa de "abre un value picker".
3. Íconos en algunos ítems y no en otros (peor que ninguno — el ojo busca un patrón que no existe).
4. Un ítem que no responde por ~100ms (Nielsen) aunque el trabajo real termine después en un toast.
5. Enterrar una acción común dentro de un submenu (los submenus cuestan un paso extra; reservarlos para lo genuinamente secundario).
6. Trigger sin acceso por teclado (onClick sin semántica de botón es invisible para navegación por teclado).

## Casos borde
Trigger cerca del borde de la pantalla: el panel debe voltear horizontalmente igual que verticalmente. Label de ítem muy largo: truncar con ellipsis, no hacer wrap (rompe el ritmo de lectura de un vistazo). Submenus anidados: 2 niveles ya es mucho, un tercero rara vez vale la pena. RTL: panel, chevron de submenu y columna de shortcuts se invierten. Touch: tap target mínimo 44×44pt, no una fila reducida.

## Componentes relacionados
- **Select**: cuando la elección guarda un valor que se usa o envía después.
- **Button**: cuando la acción no necesita ocultarse en una lista.
- **Combobox**: cuando la lista es lo bastante larga para necesitar búsqueda/filtro.
- **Link**: cuando cada ítem lleva a una URL distinta.
