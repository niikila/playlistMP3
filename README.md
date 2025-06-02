# PlaylistMP3

Aplicación Flutter para **descarga y reproducción de música MP3 mediante streaming progresivo**, con soporte para ejecución en segundo plano y notificaciones persistentes.

<div style="display: flex; align-items: center;">
  <img src="https://github.com/sabbinat/playlistMP3/blob/main/song_page.png?raw=true" width="110" height='200' style="margin-right: 10px;">
</div>

## 🎯 Funcionalidades

- Descarga progresiva (streaming) de las canciones.
- Reproducción que inicia antes de finalizar la descarga.
- Buffer inteligente para evitar interrupciones.git add .
- Notificación persistente con controles (Reproducir, Pausar, Detener).
- Interfaz amigable con:
    - Lista de canciones con título y autor;
    - Estado de la descarga (no iniciado, en progreso, descargado).
- Reproducción en segundo plano con el paquete `audio_service`.

## 👥 Integrantes del grupo

- Carolina González (@carogzv04)
- Natalie Fernández (@sabbinat)
- Nicolás Lara (@niikila)

## 🛠️ Tecnologías utilizadas

- Flutter
- Dart
- http: ^1.2.0
- just_audio: ^0.9.36
- just_audio_background: ^0.0.1-beta.10
- audio_service: ^0.18.10
- audio_session: ^0.1.16
- provider: ^6.1.2
- path_provider: ^2.0.12
- flutter_background_service: ^5.1.0
- flutter_background_service_android: ^6.3.0
- flutter_local_notifications: ^17.1.0

## 📄 Licencia

Este proyecto está licenciado bajo los términos de la **Licencia MIT**. Ver el archivo [LICENSE](LICENSE) para más información.
