# Entorno de desarrollo

Verificación realizada el 22 de octubre de 2026 con `flutter doctor -v`.

- Flutter 3.47.7, canal stable.
- Dart 3.13.5.
- Java Temurin 17.0.20.1.
- Android SDK 36.0.0 y Android Emulator 37.2.12.0.
- Android Debug Bridge 37.0.1.
- Android SDK Command-line Tools no está instalado; el estado de las licencias
  Android es desconocido. No se ha validado una compilación Android.
- No hay dispositivo Android conectado ni emulador en ejecución al verificar.
- El sistema es Windows 11. No dispone de macOS/Xcode, por lo que no puede
  compilar ni ejecutar la app iOS localmente.
- Flutter y Dart están instalados en
  `C:\workingfolder\flutter-sdk\flutter\bin`, pero esa carpeta no está en el
  `PATH` de la sesión de terminal que se utilizó para la verificación.

No se instalaron componentes del SDK ni se aceptaron licencias. La app solo
declara paquetes del SDK de Flutter (`flutter_localizations`); `flutter_lints`
se usa únicamente en desarrollo para el análisis estático. No hay dependencias
de terceros en tiempo de ejecución.
