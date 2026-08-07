Fuente: https://02ui.com/components/link/ (consultado 2026-08-05)

## Qué es
Un link lleva a otro lugar: otra página, otro sitio, u otro punto de la misma página. Si nada carga, es un botón. `<a href="...">`.

## Cuándo usarlo / Cuándo NO
Usar link cuando: el clic carga otra página (propia o externa), navega a otro punto de la misma página, descarga un archivo, abre un email o inicia una llamada, o alguien podría querer abrirlo en pestaña nueva/copiar la dirección.

Usar otra cosa cuando:
- Algo ocurre y la página se queda igual → **Button**.
- Revela un set de acciones para elegir → **Menu**.
- Cambia de panel de contenido sin cargar nada nuevo → **Tabs**.
- Enciende/apaga un setting → **Switch**.

## Variantes
Inline (dentro de una oración — aquí el subrayado NO es opcional, es lo único que separa el link del texto alrededor), Standalone (nav/lista/footer — el subrayado puede omitirse porque el espacio y la posición ya lo marcan, pero hover y focus deben decir algo), External (icono + palabras juntos dentro del link, para que el lector de pantalla anuncie ambos), Download (formato y tamaño en el texto: "Media kit (PDF, 2.4MB)"), Styled as a button (sigue siendo `<a href>` — el estilo es decisión de diseño, el elemento es decisión de comportamiento, y pueden diferir).

## Estados
Default, Hover (subrayado se engrosa o el color cambia — nunca única señal porque touch no tiene hover), Focus (ring visible, quitarlo sin reemplazo falla 2.4.7), Active, Visited (los navegadores restringen las propiedades de color por privacidad; sigue siendo relevante en listados largos de resultados), Current page (marcar con `aria-current="page"`, no solo con color).

## Comportamiento
El navegador hace todo el trabajo gratis: middle-click, cmd-click, right-click, copiar dirección, abrir en pestaña nueva, historial, URL en la status bar — todo se pierde si se reconstruye con un `<div>`. Enter sigue el link, Space hace scroll (única diferencia de teclado respecto a un botón). Sin `href`, no hay link (no es focuseable, queda fuera del tab order, reporta como "generic"). El botón "atrás" debe devolver a un estado reconocible (si el link deja atrás un scroll/filtro/valor de formulario perdido, la gente se pierde).

## Accesibilidad
- Lectores de pantalla permiten extraer todos los links de una página en una lista (NVDA/JAWS con Insert+F7, VoiceOver con el rotor) — en esa lista, el texto alrededor del link desaparece. WCAG 2.4.4 (nivel A) acepta texto que tenga sentido en contexto; 2.4.9 (AAA) pide que funcione solo. Escribir para 2.4.9 cubre ambos.
- Teclado: Tab (cada link es su propio tab stop), Enter sigue el link, Space hace scroll (nunca activa el link).
- `role="link"` en un div solo repone el nombre en el árbol de accesibilidad, no el comportamiento (se pierden tab stop, Enter, menú contextual, middle-click, status bar URL).
- Contraste: 4.5:1 contra el fondo (1.4.3); si el color es la única marca dentro de texto corrido, +3:1 contra el texto circundante y una señal en hover/focus (técnica G183). El subrayado elimina ese segundo requisito.
- Nunca color solo (WCAG 1.4.1) — el subrayado es la forma más barata de cumplirlo.
- Target size: 24×24px CSS a nivel AA (2.5.8), con excepción para links dentro de una oración; links standalone no tienen excepción.
- Pestañas nuevas: WCAG 3.2.5 (AAA) pide que se abran solo a pedido — decirlo en el texto del link cuenta como pedirlo.

## Copy
Nombrar el destino ("2026 pricing" mejor que "here"). Vincular solo las palabras que nombran la cosa. Adelantar la diferencia al inicio (la gente lee las primeras 2 palabras de una lista de links). Mismo destino = mismas palabras; destino distinto = palabras distintas (WCAG 3.2.4). Quitar "link to" (el lector de pantalla ya anuncia "link"). Dar formato y tamaño en descargas. Sentence case, sin punto final.

## Errores comunes
1. Texto de link que solo funciona en contexto ("Read more", "Learn more", "Here" — sin sentido en una lista).
2. `href="#"` con click handler encima (rompe el botón atrás y ensucia la URL — si no carga nada, debe ser botón).
3. Pestañas nuevas por defecto (quita el botón atrás, que es el control más usado para deshacer un clic).
4. Color sin subrayado dentro de un párrafo (la falla WCAG 1.4.1 más común en sitios de marketing).
5. Toda una card envuelta en un solo `<a>` (el texto deja de ser seleccionable y el nombre accesible se vuelve toda la card leída de corrido).
6. Un botón donde debería cargar una página (rompe middle-click, right-click, nueva pestaña, copiar dirección).
7. Quitar el focus ring (falla 2.4.7).

## Casos borde
Link que hace wrap en 2 líneas: se vuelve 2 rectángulos, el focus dibuja alrededor de ambos (usar `box-decoration-break: clone` para highlights). Clickable card: poner el `<a>` en el título y estirarlo con pseudo-elemento sobre la card (el título sigue siendo el nombre accesible, el resto del texto sigue seleccionable). `mailto:` sin cliente de correo: usar la dirección misma como texto del link para que se pueda copiar. Anchor links bajo header sticky: usar `scroll-margin-top` (WCAG 2.4.11). Windows High Contrast Mode: el subrayado sobrevive cuando el color no.

## Componentes relacionados
- **Button**: cuando ejecuta una acción sin navegar.
- **Menu**: cuando revela un set de acciones para elegir.
- **Card**: agrupa contenido relacionado, puede envolverse con un link (con las precauciones de arriba).
- **Tabs**: cuando cambia paneles de contenido sin cargar página.
