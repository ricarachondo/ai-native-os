Fuente: https://02ui.com/components/loading-and-skeleton/ (consultado 2026-08-05)

# Loading and skeleton

Un skeleton imita el shape del contenido que todavía no llegó. Un spinner solo dice que algo está pasando. La elección depende de cuánto dura la espera y de si ya se conoce el shape de lo que viene.

## Cuándo usarlo / Cuándo NO — usa X

Usar loading/skeleton cuando: la espera es lo bastante larga para notarse (más o menos un segundo); ya se conoce el shape de lo que viene (lista, card, perfil → **skeleton**); el shape no se conoce, o es un solo control en vez de un layout (→ **spinner**); el espacio necesita reservarse para que nada salte cuando llega el contenido real.

Cuándo NO:
- La respuesta suele terminar bien bajo un segundo — un loading state acá solo parpadea y desaparece, se lee como glitch.
- Hay progreso real y calculable (porcentaje de un upload) → usa **progress bar determinado** (componente distinto).
- El resultado volvió vacío — ese es el resultado real, no una espera → usa **empty state**.
- La condición es continua, no una espera puntual (cuenta en revisión) → usa **banner**.

## Variantes

- **Skeleton, list shape**: filas de avatar + dos líneas repetidas; feed, inbox, tabla por poblarse.
- **Skeleton, card shape**: bloque ancho para imagen + un par de líneas de texto debajo; grid de cards o un perfil.
- **Spinner**: indicador rotativo sin shape propio; botón en submit, o cualquier espera muy corta o impredecible para modelar.
- **Inline spinner**: mismo indicador, más chico, al lado de la pieza específica de contenido que reemplaza (ej. una fila refrescando dentro de una tabla ya cargada).
- **Progress bar** (mencionado, no cubierto acá): determinado, con porcentaje real — la tercera opción a tener presente aunque sea un componente separado.

## Estados

Idle (contenido real, nada cargando) → Pending under threshold (nada se renderiza — deliberado, mostrar algo acá solo agrega un flash innecesario) → Pending skeleton (shape y pulse en lugar del contenido, match cercano de layout para que el swap no mueva nada) → Pending spinner (indicador rotativo, nunca atrapa foco ni bloquea input) → Resolved (contenido real reemplaza el placeholder sin salto si el placeholder estaba bien dimensionado) → Failed (mensaje de error reemplaza el placeholder, no un spinner estancado — indistinguible de algo roto).

## Comportamiento clave

- Aparece después de un delay corto, no instantáneo: ~200-300ms es práctica común, para que una respuesta rápida nunca muestre nada.
- Nunca atrapa foco ni bloquea la página, salvo que la acción genuinamente no pueda interrumpirse (pago en submit) — y en ese caso, decirlo explícitamente.
- Resuelve en contenido o error, nunca en nada: un spinner o skeleton que se queda indefinido es indistinguible de la interfaz rota.
- Reserva el espacio que va a usar el contenido real — eso es lo que un skeleton hace que un spinner no.

## Accesibilidad

- Ninguno de los dos es interactivo, ninguno es tab stop; el foco debe estar donde estaba antes de que arrancara la request.
- Anunciar una sola vez, no en cada re-render: `aria-live="polite"` en el contenedor, actualizado solo cuando el estado cambia de loading a resolved.
- `aria-busy="true"` en la región que carga, se limpia en cuanto entra el contenido real.
- Respetar `prefers-reduced-motion`: tanto el pulse del skeleton como la rotación del spinner deben frenar o detenerse.
- Contraste aplica también al placeholder aunque no tenga texto: suficiente contraste contra el fondo para leerse como presente (WCAG 1.4.11 para componentes UI no textuales).
- Nunca solo color para un load fallido: emparejar con ícono o palabra (WCAG 1.4.1).

## Copy

- Generalmente nada: un skeleton o spinner se entiende sin caption en casi todo contexto — agregar "Loading..." al lado de un shape que ya comunica eso es la info dos veces.
- Cuando sí habla, ser específico: "Loading your projects" mejor que un "Loading" pelado, si la espera dura lo suficiente para que valga la pena leerlo.
- Nunca prometer un tiempo que no se puede garantizar: "This may take a moment" es honesto; "Almost done" en un spinner que lleva 30 segundos rompe confianza más rápido que no decir nada.

## Errores comunes

1. Skeleton cuyas proporciones no calzan con el contenido real: el propósito era evitar el salto de layout y un shape mal calzado lo causa igual.
2. Mostrar loading state para una respuesta que termina en 100ms: solo se ve un flash, se lee como flicker.
3. Spinner que nunca resuelve: nada distingue "sigue trabajando" de "silenciosamente roto".
4. Todos los bloques de skeleton del mismo ancho exacto: el texto real varía, una fila de barras idénticas se lee como artificial.
5. Skeleton para contenido que ya falló al cargar — en ese punto ya no está cargando, hay que mostrar el error.
6. Bloquear input para un refresh en background que no lo necesitaba (ej. un feed pulling nuevos items no debería congelar la pantalla).

## Casos borde

- La espera supera los 10 segundos (tercer límite de Nielsen): agregar un mensaje real y un indicador de progreso si hay forma de calcularlo, no dejar un spinner corriendo sin más.
- Request falla después de que el skeleton ya estaba mostrándose: swap directo al estado de error, no dejar el skeleton implicando que la espera sigue activa.
- Alguien navega fuera mid-load: cancelar la request pendiente si la API lo soporta.
- Respuesta parcial: resolver cada sección de forma independiente en vez de mantener todo el skeleton hasta que llegue la última pieza.
- `prefers-reduced-motion`: fallback estático o muy atenuado tanto para el pulse como para el spin.

## Componentes relacionados

- **Empty state**: la pantalla cuando no hay nada que mostrar — el siguiente paso después de que un loading state resuelve en cero resultados.
- **Banner**: mensaje persistente hasta que cambia la condición de fondo — para condiciones continuas, no esperas puntuales.
- **Card**: agrupa contenido relacionado en una unidad visible — el skeleton de shape "card" imita su layout.

Distinción clave del sitio: skeleton vs spinner se resuelve preguntando si se conoce el shape de lo que viene. Un perfil, tabla o feed renderiza el mismo layout siempre → skeleton. Un botón haciendo una acción puntual, o un resultado cuyo shape no se puede predecir → spinner.
