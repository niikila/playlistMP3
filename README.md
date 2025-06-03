# PlaylistMP3

Aplicación Flutter para **descarga y reproducción de música MP3 mediante streaming progresivo**, con soporte para ejecución en segundo plano y notificaciones persistentes.

<div style="display: flex; align-items: center;">
  <img src="https://github.com/sabbinat/playlistMP3/blob/main/song_page.png?raw=true" width="110" height='200' style="margin-right: 10px;">
</div>

## 🎯 Funcionalidades

- Descarga progresiva (streaming) de canciones: inicia la reproducción antes de que finalice la descarga completa.
- Buffer inteligente que minimiza interrupciones durante la reproducción.
- Notificaciones persistentes con controles: reproducir, pausar, detener, siguiente y anterior.
- Reproducción en segundo plano usando el paquete audio_service.
- Interfaz amigable con:
  - Lista de canciones mostrando título, autor y estado de descarga.
  - Indicador visual del progreso de descarga.
- Gestión de descargas:
  - Descarga de archivos en segundo plano.
  - Actualización en tiempo real del progreso.
  - Manejo de archivos descargados para reproducción offline.
- Manejo de estado centralizado mediante ChangeNotifier para facilitar la actualización de UI.

## 👥 Integrantes del grupo

- Carolina González - (@carogzv04)
- Natalie Fernández - (@sabbinat)
- Nicolás Lara - (@niikila)

## Tecnologías y paquetes principales

- Flutter y Dart

- Gestión audio y reproducción:
  - just_audio
  - audio_service
  - just_audio_background
  - audio_session
- Descargas y servicios en background:
  - flutter_background_service
  - flutter_local_notifications
- Manejo de estado con provider
- Acceso a archivos locales con path_provider
- Peticiones HTTP con http

## 📄 Licencia

Este proyecto está licenciado bajo los términos de la **Licencia MIT**. Ver el archivo [LICENSE](LICENSE) para más información.
