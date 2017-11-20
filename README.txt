La idea de este juego no es original. El programa esta basado en el juego trench
que se fundó en un kickstarter, para saber más sobre el juego visitar el siguiente
enlace: https://www.kickstarter.com/projects/outerlimitgames/trench-play-with-art-0.
Algunos nombres han sido cambiados para mejorar la impresión por pantalla.

Para compilar el juego:
    1) Abrir terminal de linux.
    2) Colocarse sobre el directorio que contiene el juego.
    3) Ejecutar $ gnatmake trench.adb.

Output esperado:
    gcc-5 -c trench.adb
    gcc-5 -c control_logic.adb
    gcc-5 -c exceptions.ads
    gcc-5 -c dcomponents.adb
    gnatbind-5 -x trench.ali
    gnatlink-5 trench.ali

Para ejecutar el juego:
    1) Compilar el juego.
    2) Ejecutar en la terminal $ ./trench
