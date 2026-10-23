# Roadmap

## V0.1

**Issue 1 — Crear estructura base del proyecto Flutter**

**Title**

Foundation: Crear estructura base del proyecto Flutter

**Description**

Crear la estructura inicial del proyecto Flutter para **¿Cuánto recuerdas?**, siguiendo una arquitectura sencilla por capas y evitando introducir complejidad innecesaria.

La aplicación debe quedar preparada para separar claramente:

* Presentation/UI  
* Domain/game logic  
* Data/repositories  
* Local persistence  
* Static content  
* Services

La aplicación debe arrancar correctamente en Android y iOS.

La estructura debe permitir que la lógica del juego pueda probarse sin depender de widgets Flutter.

**Acceptance Criteria**

* El proyecto Flutter compila correctamente.  
* La aplicación arranca en Android.  
* La aplicación arranca en iOS.  
* Existe una estructura clara de carpetas para presentation, domain, data, services y content.  
* La lógica de dominio no depende de Flutter UI.  
* No se añade ningún backend.  
* No se añade autenticación.  
* No se añade analytics.  
* No se añade AdMob.  
* Se documentan brevemente las decisiones arquitectónicas principales.  
* Se mantienen las dependencias externas al mínimo razonable.

**Dependencies**

Ninguna.

**Agent Instructions**

Implementa únicamente la infraestructura base. No implementes todavía lógica de juego, persistencia, UI completa ni contenido. No introduzcas patrones arquitectónicos complejos si no son necesarios. Prioriza una estructura sencilla que permita que varios agentes trabajen posteriormente en paralelo.

---

**Issue 2 — Definir modelos de dominio**

**Title**

Domain: Definir modelos de dominio del juego

**Description**

Crear los modelos Dart que representan el dominio de **¿Cuánto recuerdas?**.

Como mínimo:

* Question  
* Answer  
* Quiz  
* QuizQuestion  
* QuizResult  
* DailyProgress  
* GameStatistics

Los modelos deben representar únicamente conceptos del dominio y no depender de widgets ni de la implementación concreta de persistencia.

**Acceptance Criteria**

* Todos los modelos están definidos.  
* Los tipos de datos están correctamente definidos.  
* Los modelos son inmutables cuando sea apropiado.  
* Question permite representar exactamente cuatro respuestas.  
* Question permite identificar inequívocamente la respuesta correcta.  
* Question contiene ID estable, categoría, década/año, texto y explicación.  
* Los modelos no dependen de Flutter UI.  
* Existen tests para las partes relevantes del dominio.  
* Se documentan las decisiones no obvias.

**Dependencies**

Issue 1\.

**Agent Instructions**

No implementes todavía almacenamiento ni carga JSON. Define contratos de dominio estables que los demás agentes puedan utilizar. Si necesitas tomar una decisión no especificada, elige la alternativa más sencilla y documenta la decisión.

---

**Issue 3 — Definir formato y validador del banco de preguntas**

**Title**

Content: Definir formato JSON y validador del banco de preguntas

**Description**

Definir el formato versionado del banco de preguntas y crear un validador que permita detectar errores antes de incorporar contenido a la aplicación.

El banco tendrá inicialmente 500 preguntas.

Cada pregunta debe contener:

* ID estable  
* categoría  
* década/año  
* pregunta  
* exactamente cuatro respuestas  
* una única respuesta correcta  
* explicación

El banco debe incluir una versión explícita.

**Acceptance Criteria**

* Existe un formato JSON documentado.  
* El JSON contiene versión del banco.  
* Los IDs son únicos.  
* Cada pregunta tiene exactamente cuatro respuestas.  
* Cada pregunta tiene exactamente una respuesta correcta.  
* Se validan categorías permitidas.  
* Se validan décadas/años permitidos.  
* Se validan campos obligatorios.  
* El validador detecta IDs duplicados.  
* El validador detecta preguntas inválidas.  
* El proceso devuelve errores suficientemente claros.  
* Existe al menos un ejemplo válido.  
* Existen ejemplos de contenido inválido cubiertos por tests.

**Dependencies**

Issue 2\.

**Agent Instructions**

El formato debe ser estable y fácil de mantener manualmente. No diseñes un sistema de CMS ni una infraestructura de generación compleja. El objetivo es disponer de un JSON versionado dentro de los assets de Flutter.

---

**Issue 4 — Crear banco inicial de 500 preguntas**

**Title**

Content: Crear banco inicial de 500 preguntas

**Description**

Crear el banco inicial completo de 500 preguntas en español de España.

Distribución objetivo:

| Categoría | Cantidad |
| :---- | :---- |
| TV | 125 |
| Música | 100 |
| Cine | 100 |
| Videojuegos / tecnología | 75 |
| Cultura cotidiana / recuerdos | 100 |

Las preguntas deben cubrir razonablemente las décadas de los 80, 90 y 2000\.

Cada pregunta debe tener:

* una única respuesta correcta  
* tres distractores plausibles  
* explicación  
* información de década/año  
* ID estable

**Acceptance Criteria**

* Existen exactamente 500 preguntas.  
* La distribución por categorías coincide con la especificada.  
* Las preguntas están repartidas entre los 80, 90 y 2000\.  
* Cada pregunta tiene exactamente cuatro respuestas.  
* Cada pregunta tiene exactamente una correcta.  
* Todas tienen explicación.  
* No existen IDs duplicados.  
* El banco pasa el validador.  
* Las preguntas están redactadas en español de España.  
* Se evita contenido ambiguo cuando sea posible.  
* Se evita que la respuesta correcta sea deducible simplemente por longitud o redacción.  
* No se introducen preguntas que dependan de información posterior a la época indicada salvo que sea intencionado y esté claramente justificado.

**Dependencies**

Issue 3\.

**Agent Instructions**

Esta tarea es principalmente de generación/revisión de contenido. No modifiques el motor del juego ni la arquitectura. Si se detectan problemas en el esquema JSON, documenta el problema en lugar de cambiar unilateralmente el contrato definido en el Issue 3\.

---

**Issue 5 — Implementar QuestionRepository**

**Title**

Data: Implementar QuestionRepository

**Description**

Implementar el repositorio responsable de cargar y consultar el banco de preguntas desde los assets de la aplicación.

Debe abstraer completamente a los consumidores de la ubicación física del JSON.

Operaciones mínimas:

* cargar banco  
* obtener todas las preguntas  
* obtener por categoría  
* obtener por década  
* obtener por ID  
* obtener versión del banco

**Acceptance Criteria**

* El JSON se carga desde los assets de Flutter.  
* El repositorio expone una API clara.  
* El resto de la aplicación no necesita conocer la ruta física del JSON.  
* Se puede obtener la versión del banco.  
* Se pueden consultar preguntas por ID.  
* Se pueden consultar preguntas por categoría.  
* Se pueden consultar preguntas por década.  
* Los errores de carga se gestionan adecuadamente.  
* Existen tests.  
* El repositorio no contiene lógica de selección del quiz diario.

**Dependencies**

Issues 2 y 3\.

**Agent Instructions**

Mantén el repositorio centrado exclusivamente en acceso al contenido. No implementes aquí la selección diaria ni reglas de negocio.

---

**Issue 6 — Implementar generador determinista del quiz diario**

**Status**

Completed on 2026-10-23. GitHub Issue #17 was closed after PR #18 was merged into `main` (merge commit `e734064bf2dbb88531e94e9259f2f7dc0bed2de7`).

**Title**

Game: Implementar selección determinista del quiz diario

**Description**

Crear DailyQuizGenerator.

El generador debe seleccionar exactamente cinco preguntas utilizando:

* fecha local  
* versión del banco  
* banco de preguntas

La misma combinación de fecha y versión debe producir siempre la misma selección.

Debe existir una mezcla razonable de categorías y décadas.

No debe repetirse una pregunta dentro del mismo quiz.

**Acceptance Criteria**

* Siempre se seleccionan 5 preguntas cuando existe suficiente contenido.  
* No existen duplicados dentro del quiz.  
* Misma fecha \+ misma versión → mismo resultado.  
* Cambiar la fecha puede producir un resultado diferente.  
* Cambiar la versión del banco puede producir un resultado diferente.  
* La selección no depende de un RNG no determinista.  
* Existe una estrategia explícita para mezclar categorías.  
* Existe una estrategia explícita para mezclar décadas.  
* El algoritmo está cubierto por tests.  
* El algoritmo no depende de la UI.  
* El algoritmo no necesita backend.

**Dependencies**

Issue 5\.

**Agent Instructions**

Este es uno de los componentes más importantes del proyecto. Hazlo completamente determinista y fácilmente testeable. Documenta el algoritmo utilizado. No optimices prematuramente.

---

**Issue 7 — Implementar scoring**

**Title**

Game: Implementar sistema de puntuación

**Description**

Implementar la lógica que calcula el resultado de un quiz.

Debe calcular:

* aciertos  
* errores  
* puntuación  
* porcentaje  
* detalle de cada respuesta

La puntuación debe ser independiente de la UI.

**Acceptance Criteria**

* Se pueden evaluar las cinco preguntas.  
* Se contabilizan correctamente los aciertos.  
* Se contabilizan correctamente los errores.  
* Se calcula porcentaje.  
* Se genera un resultado de dominio.  
* No se puede contabilizar dos veces la misma respuesta.  
* Existen tests para 0/5, 1/5, 2/5, 3/5, 4/5 y 5/5.  
* La lógica no depende de Flutter UI.

**Dependencies**

Issue 2\.

**Agent Instructions**

Mantén la lógica sencilla. No introduzcas multiplicadores, puntos especiales ni gamificación adicional que no esté definida en la especificación.

---

**Issue 8 — Implementar fechas y rachas**

**Title**

Game: Implementar gestión de fechas y rachas

**Description**

Implementar la lógica responsable del día actual y de las rachas.

Debe determinar:

* si el quiz de hoy ya se completó  
* si el usuario jugó ayer  
* si continúa la racha  
* cuándo se rompe  
* cuál es la racha actual  
* cuál es la mejor racha

La lógica debe utilizar fecha local y estar aislada de la UI.

**Acceptance Criteria**

* Primer quiz → racha 1\.  
* Completar un quiz al día siguiente → incrementa la racha.  
* Saltarse un día → rompe la racha.  
* Repetir comprobaciones del mismo día no altera la racha.  
* Se distingue correctamente entre hoy y ayer.  
* Se gestionan cambios de fecha.  
* Existen tests exhaustivos.  
* Los tests permiten controlar la fecha actual mediante una abstracción.  
* No se utilizan directamente llamadas a reloj del sistema en la lógica testeable.

**Dependencies**

Issue 2\.

**Agent Instructions**

Presta especial atención a timezone y medianoche. No bases los tests en la fecha real del sistema. Utiliza una abstracción de reloj/fecha que pueda sustituirse durante los tests.

---

**Issue 9 — Implementar almacenamiento local**

**Title**

Data: Implementar persistencia local

**Description**

Implementar la primera solución de persistencia local de la aplicación.

Debe permitir almacenar como mínimo:

* quizzes completados  
* puntuación  
* fecha  
* racha  
* estadísticas  
* histórico básico

La tecnología concreta debe mantenerse encapsulada.

**Acceptance Criteria**

* Los datos sobreviven al reinicio de la aplicación.  
* Se puede guardar el resultado diario.  
* Se puede recuperar el resultado.  
* Se puede almacenar la racha.  
* Se pueden almacenar estadísticas.  
* Se puede recuperar histórico básico.  
* La lógica de juego no depende directamente de la implementación de almacenamiento.  
* Existe una estrategia razonable de versionado/migración del almacenamiento.  
* Existen tests.

**Dependencies**

Issue 2\.

**Agent Instructions**

Escoge una solución local sencilla y apropiada para el volumen de datos. No introduzcas una base de datos compleja si no es necesaria. Mantén la implementación sustituible.

---

**Issue 10 — Implementar ProgressRepository**

**Title**

Data: Implementar ProgressRepository

**Description**

Crear el repositorio de alto nivel que encapsule el progreso del jugador.

Debe proporcionar operaciones similares a:

getTodayProgress()

saveQuizResult()

getStatistics()

getCurrentStreak()

getHistory()

Debe combinar la persistencia con los modelos de dominio sin exponer detalles internos de almacenamiento.

**Acceptance Criteria**

* Existe ProgressRepository.  
* Se puede consultar el progreso de hoy.  
* Se puede guardar un resultado.  
* Se pueden consultar estadísticas.  
* Se puede consultar la racha.  
* Se puede consultar histórico.  
* No se expone la implementación concreta del almacenamiento.  
* Existen tests.  
* Guardar dos veces el mismo quiz no duplica estadísticas.

**Dependencies**

Issues 8 y 9\.

**Agent Instructions**

El repositorio debe convertirse en el único punto de acceso al progreso desde las capas superiores. Evita que las pantallas manipulen directamente almacenamiento.

---

**Issue 11 — Tests de persistencia y recuperación**

**Title**

Tests: Validar persistencia y recuperación del progreso

**Description**

Crear una batería de tests específica para garantizar que los datos del jugador se mantienen correctamente.

**Acceptance Criteria**

* Guardar y recuperar un resultado.  
* Reiniciar/recrear el repositorio y recuperar datos.  
* Recuperar quiz completado.  
* Recuperar estadísticas.  
* Recuperar racha.  
* Recuperar histórico.  
* Manejar ausencia de datos.  
* Evitar duplicados.  
* Cubrir migración/versionado si aplica.

**Dependencies**

Issue 10\.

**Agent Instructions**

No cambies la arquitectura para facilitar los tests. Si encuentras problemas de diseño, documéntalos y realiza únicamente cambios necesarios para hacer el comportamiento correcto y testeable.

---

**Issue 12 — Crear abstracción AdService**

**Title**

Services: Crear abstracción AdService

**Description**

Crear una abstracción para publicidad que permita incorporar Google AdMob posteriormente sin modificar la lógica principal del juego.

La aplicación V0.1 no debe utilizar ningún SDK publicitario.

La interfaz debe contemplar las necesidades previsibles sin acoplarse a AdMob.

**Acceptance Criteria**

* Existe AdService.  
* La interfaz no contiene tipos específicos de AdMob.  
* La lógica de juego puede depender de AdService.  
* No se añade dependencia de AdMob.  
* No se inicializa ninguna publicidad.  
* La interfaz permite implementar posteriormente publicidad sin modificar el dominio.

**Dependencies**

Issue 1\.

**Agent Instructions**

No sobre-diseñes la API. Define únicamente las operaciones necesarias para la aplicación actual y las que sean razonablemente necesarias para una futura implementación de AdMob.

---

**Issue 13 — Implementar NoOpAdService**

**Title**

Services: Implementar NoOpAdService

**Description**

Crear la implementación por defecto de AdService.

Durante V0.1 no debe mostrar publicidad ni cargar SDKs.

**Acceptance Criteria**

* Existe NoOpAdService.  
* Implementa completamente AdService.  
* Todas las operaciones son seguras aunque no hagan nada.  
* No se carga AdMob.  
* La aplicación utiliza NoOpAdService por defecto.  
* Existen tests básicos.

**Dependencies**

Issue 12\.

**Agent Instructions**

No añadas placeholders visuales de anuncios salvo que sean necesarios para probar layout. El comportamiento por defecto debe ser completamente silencioso.

---

**Issue 14 — Crear sistema visual retro moderno**

**Title**

UI: Crear tema visual retro moderno

**Description**

Crear el sistema visual inicial de **¿Cuánto recuerdas?**.

El estilo debe ser:

* retro moderno  
* atractivo  
* sencillo  
* legible  
* orientado a sesiones cortas

Crear tema y componentes reutilizables.

**Acceptance Criteria**

* Existe tema global.  
* Se definen colores principales.  
* Se define tipografía.  
* Se definen estilos de botones.  
* Se definen cards.  
* Se definen estados de respuesta correcta/incorrecta.  
* Se mantienen espaciados coherentes.  
* Se contempla accesibilidad básica.  
* Funciona correctamente en diferentes tamaños de pantalla.  
* No se duplica styling innecesariamente entre pantallas.

**Dependencies**

Issue 1\.

**Agent Instructions**

No implementes todavía el flujo completo del juego. Crea los componentes y el tema necesarios para que otros agentes puedan construir las pantallas encima.

---

**Issue 15 — Implementar Home**

**Title**

UI: Implementar pantalla principal

**Description**

Crear la pantalla principal de la aplicación.

Debe mostrar:

* identidad de la aplicación  
* estado del quiz de hoy  
* botón para jugar  
* racha  
* acceso a estadísticas

Si el quiz ya está completado debe indicarlo claramente.

**Acceptance Criteria**

* Home se muestra al iniciar.  
* Se muestra correctamente el estado del quiz.  
* El botón "Jugar" inicia el quiz cuando corresponde.  
* Un quiz completado no puede iniciarse accidentalmente de nuevo.  
* Se muestra la racha.  
* Existe acceso a estadísticas.  
* La pantalla utiliza el tema global.  
* No contiene lógica de selección del quiz.  
* No accede directamente a almacenamiento.

**Dependencies**

Issues 6, 10 y 14\.

**Agent Instructions**

La pantalla debe consumir casos de uso/repositorios, no implementar reglas de negocio. Mantén el widget relativamente fino.

---

**Issue 16 — Implementar pantalla de quiz**

**Title**

UI: Implementar pantalla del quiz diario

**Description**

Crear el flujo de preguntas del quiz diario.

Cada pregunta debe mostrar:

* progreso 1/5  
* pregunta  
* cuatro respuestas

Tras seleccionar una respuesta:

* indicar correcto/incorrecto  
* mostrar explicación  
* permitir continuar

No se debe poder responder dos veces a una pregunta.

**Acceptance Criteria**

* Se muestran las cinco preguntas.  
* Se muestra progreso.  
* Se muestran exactamente cuatro respuestas.  
* La respuesta seleccionada queda registrada.  
* Se muestra feedback.  
* Se muestra explicación.  
* Una pregunta no puede responderse dos veces.  
* El usuario puede avanzar a la siguiente.  
* Tras la quinta pregunta se genera el resultado.  
* No se puede saltar una pregunta.  
* El flujo funciona sin backend.

**Dependencies**

Issues 6, 7 y 14\.

**Agent Instructions**

No implementes el algoritmo de selección ni scoring dentro del widget. Consume los servicios/casos de uso definidos por dominio.

---

**Issue 17 — Implementar pantalla de resultados**

**Title**

UI: Implementar pantalla de resultados

**Description**

Crear la pantalla mostrada después de completar el quiz.

Debe mostrar:

* puntuación  
* aciertos  
* porcentaje  
* racha  
* resumen de respuestas  
* botón compartir  
* navegación a Home

**Acceptance Criteria**

* Se muestran correctamente los resultados.  
* Se muestra la puntuación.  
* Se muestran los aciertos.  
* Se muestra porcentaje.  
* Se muestra la racha actual.  
* Se muestra resumen de respuestas.  
* Se puede volver a Home.  
* Se puede iniciar el flujo de compartir.  
* El resultado mostrado coincide con el resultado persistido.

**Dependencies**

Issues 7, 8, 10 y 14\.

**Agent Instructions**

No recalcules el resultado en la UI. La pantalla debe recibir un QuizResult ya calculado.

---

**Issue 18 — Implementar estadísticas**

**Title**

UI: Implementar pantalla de estadísticas

**Description**

Crear la pantalla de estadísticas básicas.

Mostrar:

* quizzes completados  
* preguntas respondidas  
* aciertos  
* porcentaje global  
* mejor puntuación  
* racha actual  
* mejor racha

**Acceptance Criteria**

* Todas las estadísticas se muestran correctamente.  
* Los valores proceden del repositorio.  
* Se actualizan después de completar un quiz.  
* Se contempla el estado sin datos.  
* La pantalla no accede directamente al almacenamiento.  
* El diseño sigue el tema visual.

**Dependencies**

Issues 10 y 14\.

**Agent Instructions**

No añadas gráficas complejas en V0.1. El objetivo es proporcionar una visión rápida y clara del progreso.

---

**Issue 19 — Implementar compartir resultado**

**Title**

UI: Implementar compartir resultado

**Description**

Implementar la funcionalidad de compartir el resultado mediante el mecanismo nativo de Android/iOS.

El texto debe generarse dinámicamente.

Ejemplo:

🧠 ¿Cuánto recuerdas?  
 Hoy he conseguido 4/5.  
 🔥 Racha: 7 días  
 ¿Tú cuánto recuerdas?

**Acceptance Criteria**

* Existe botón de compartir.  
* Se utiliza el mecanismo nativo de sharing.  
* El texto contiene la puntuación.  
* El texto contiene la racha.  
* El texto se genera dinámicamente.  
* Funciona en Android.  
* Funciona en iOS.  
* No se introduce dependencia de backend.

**Dependencies**

Issue 17\.

**Agent Instructions**

Mantén la generación del texto separada del widget para poder modificar posteriormente el formato de compartir sin tocar la pantalla.

---

**Issue 20 — Tests unitarios del motor del juego**

**Title**

Tests: Cubrir motor de selección y puntuación

**Description**

Crear una suite completa de tests para el núcleo del juego.

Debe cubrir especialmente el generador determinista y el scoring.

**Acceptance Criteria**

* Misma fecha/version produce mismo quiz.  
* Diferentes fechas producen selecciones diferentes cuando existe suficiente banco.  
* Diferentes versiones pueden producir selecciones diferentes.  
* Nunca hay duplicados.  
* Se seleccionan exactamente cinco preguntas.  
* Se respetan las restricciones de categorías.  
* Se respetan las restricciones de décadas.  
* Scoring 0/5.  
* Scoring 1/5.  
* Scoring 2/5.  
* Scoring 3/5.  
* Scoring 4/5.  
* Scoring 5/5.  
* Se cubren casos límite.

**Dependencies**

Issues 6 y 7\.

**Agent Instructions**

Prioriza tests deterministas y reproducibles. Si detectas que el diseño actual dificulta testear una regla, mejora la testabilidad sin introducir complejidad innecesaria.

---

**Issue 21 — Tests de fechas y rachas**

**Title**

Tests: Cubrir fechas, progreso diario y rachas

**Description**

Crear una batería exhaustiva de tests para garantizar que la lógica temporal es correcta.

**Acceptance Criteria**

* Primer quiz genera racha 1\.  
* Dos días consecutivos generan racha 2\.  
* Tres días consecutivos generan racha 3\.  
* Saltar un día rompe la racha.  
* Completar dos veces el mismo día no incrementa la racha.  
* Un día sin datos se gestiona correctamente.  
* Se actualiza correctamente la mejor racha.  
* Se prueban cambios de medianoche.  
* Se prueban cambios de mes.  
* Se prueban cambios de año.  
* Los tests no dependen del reloj real.

**Dependencies**

Issue 8\.

**Agent Instructions**

Esta suite debe detectar regresiones relacionadas con fechas. Utiliza un reloj inyectable/falso en lugar de modificar fechas reales del sistema.

---

**Issue 22 — Tests de integración del flujo completo**

**Title**

Tests: Cubrir flujo completo del quiz diario

**Description**

Crear tests de integración para comprobar el flujo completo:

Home

 ↓

Jugar

 ↓

5 preguntas

 ↓

Resultado

 ↓

Persistencia

 ↓

Home

**Acceptance Criteria**

* El usuario puede iniciar el quiz.  
* Puede responder cinco preguntas.  
* Se genera correctamente el resultado.  
* El resultado se persiste.  
* La racha se actualiza.  
* Home reconoce que el quiz ya está completado.  
* El estado permanece después de recrear la aplicación/repositorios.  
* Las estadísticas reflejan el quiz completado.

**Dependencies**

Issues 15, 16, 17 y 10\.

**Agent Instructions**

No sustituyas toda la lógica por mocks. Utiliza mocks/fakes únicamente donde sea apropiado y verifica el flujo real entre las principales capas.

---

**Issue 23 — Configurar identidad y metadata de la aplicación**

**Title**

Release: Configurar nombre, icono, splash y metadata

**Description**

Preparar la identidad de **¿Cuánto recuerdas?** para Android e iOS.

Debe incluir:

* nombre  
* icono  
* splash screen  
* identificadores de aplicación  
* versión inicial  
* metadata básica

**Acceptance Criteria**

* El nombre aparece correctamente en Android.  
* El nombre aparece correctamente en iOS.  
* Icono configurado.  
* Splash configurado.  
* Versionado inicial configurado.  
* Package/bundle identifiers coherentes.  
* No existen nombres temporales de plantilla Flutter.

**Dependencies**

Issue 1\.

**Agent Instructions**

No configures todavía publicación en stores ni certificados reales. Deja preparada la estructura para ello.

---

**Issue 24 — Configurar build Android**

**Title**

Release: Preparar build Android

**Description**

Preparar el proyecto para generar una versión Android distribuible.

Debe contemplar:

* debug  
* release  
* APK  
* AAB  
* configuración de signing preparada

**Acceptance Criteria**

* Debug funciona.  
* Release compila.  
* Se puede generar APK.  
* Se puede generar AAB.  
* La configuración de signing no contiene secretos en el repositorio.  
* Los identificadores son correctos.  
* Se documenta cómo generar el build.

**Dependencies**

Issue 23\.

**Agent Instructions**

No introduzcas credenciales reales. Utiliza configuración segura y documenta qué secretos/certificados deberá proporcionar posteriormente el propietario del proyecto.

---

**Issue 25 — Configurar build iOS**

**Title**

Release: Preparar build iOS

**Description**

Preparar el proyecto para compilar correctamente en iOS.

Debe incluir:

* configuración iOS  
* bundle identifier  
* build de desarrollo  
* simulador  
* preparación para distribución

**Acceptance Criteria**

* El proyecto compila en iOS.  
* Funciona en simulador.  
* Bundle identifier configurado.  
* Nombre de aplicación correcto.  
* Versionado configurado.  
* No se incluyen certificados privados.  
* Se documentan los pasos necesarios para distribución.

**Dependencies**

Issue 23\.

**Agent Instructions**

No intentes resolver credenciales Apple del propietario. El objetivo es dejar el proyecto técnicamente preparado.

---

**Issue 26 — Documentación técnica final**

**Title**

Documentation: Documentar arquitectura y desarrollo

**Description**

Crear documentación técnica suficiente para que otro desarrollador/agente pueda continuar el proyecto sin depender del contexto de este chat.

Debe documentar:

* arquitectura  
* estructura de carpetas  
* ejecución local  
* tests  
* formato del banco JSON  
* generación del quiz  
* determinismo  
* persistencia  
* estadísticas  
* rachas  
* AdService  
* cómo añadir nuevas preguntas  
* cómo sustituir NoOpAdService por AdMob

**Acceptance Criteria**

* Existe documentación de arquitectura.  
* Existe documentación para ejecutar el proyecto.  
* Existe documentación para ejecutar tests.  
* Se documenta el formato JSON.  
* Se documenta el algoritmo de selección.  
* Se documenta la lógica de fechas/rachas.  
* Se documenta la persistencia.  
* Se documenta la arquitectura de publicidad.  
* Se explica cómo añadir preguntas.  
* Se explica cómo incorporar AdMob posteriormente.  
* La documentación no contiene información sensible.

**Dependencies**

Issues 1–25, o al menos todos los componentes que finalmente hayan sido implementados.

**Agent Instructions**

Documenta el comportamiento real del código, no el comportamiento deseado. Si durante la implementación se han tomado decisiones distintas de las inicialmente previstas, refleja las decisiones finales y explica brevemente por qué.

