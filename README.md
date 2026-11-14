# SBE Móvil | Tamizajes de bienestar universitario

Aplicación móvil académica para la comunidad de la UCEVA. Ofrece tamizajes orientativos, recomendaciones y un historial personal de resultados. Los resultados no constituyen un diagnóstico ni reemplazan la atención profesional.

## Qué incluye

- Registro e inicio de sesión con correo institucional verificado.
- Caracterización del participante y consentimiento informado.
- Cuestionarios con una pregunta por pantalla, progreso y confirmación al salir.
- Resultado con termómetro, interpretación y recomendaciones.
- Historial personal en **Mis resultados**.

| Módulo | Preguntas | Rango de puntuación |
| --- | ---: | ---: |
| Violentómetro | 21 | 21–105 |
| Bienestar emocional | 21 | 21–105 |
| Carga académica | 18 | 18–90 |


## Firebase y acceso

La aplicación usa Firebase Authentication y Cloud Firestore. Para probar los módulos con el proyecto configurado en el repositorio, se necesita conexión a internet y una cuenta institucional `@uceva.edu.co` con el correo verificado y el perfil con consentimiento completado. Si el docente no tiene correo institucional, coordina una demostración en el emulador con una cuenta autorizada, sin compartir contraseñas.

Firestore guarda el puntaje, nivel, módulo, fecha y versión del algoritmo. El Violentómetro también registra el contexto. No se guardan las respuestas individuales en el historial. Cada participante solo puede consultar sus propios resultados desde la app. El archivo `firestore.rules` documenta las reglas de los tres módulos. Agregarlo a Git no cambia las reglas publicadas.

Si usas un proyecto Firebase diferente, debes configurar Flutter para ese proyecto, habilitar el proveedor de correo y contraseña y configurar en Firestore los documentos activos de `modulos` que usa la app. Las reglas por sí solas no crean esos documentos.

