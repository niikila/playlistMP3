import 'dart:io';
import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/song_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:path_provider/path_provider.dart';

class SongViewmodel extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _lastNotifiedPosition = Duration.zero;

  late final StreamSubscription<Duration?> _durationSub;
  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<PlayerState> _playerStateSub;

  List<Song> _playlist = [];
  int _currentSongIndex = -1;
  bool _isLoading = false;
  String? _error;

  SongViewmodel() {
    listenToDuration();

    FlutterBackgroundService().on('downloadProgress').listen((event) {
      final filename = event?['filename'] as String?;
      final progress = event?['progress'] as double?;

      if (filename != null && progress != null) {
        Song? song;
        try {
          song = _playlist.firstWhere((s) => _fileNameForSong(s) == filename);
        } catch (_) {
          song = null;
        }

        if (song != null) {
          song.downloadProgress = progress;
          notifyListeners();
        }
      }
    });

    FlutterBackgroundService().on('downloadComplete').listen((event) {
      final filename = event?['filename'] as String?;

      if (filename != null) {
        Song? song;
        try {
          song = _playlist.firstWhere((s) => _fileNameForSong(s) == filename);
        } catch (_) {
          song = null;
        }

        if (song != null) {
          song.isDownloaded = true;
          song.downloadProgress = 1.0;
          notifyListeners();
        }

        FlutterBackgroundService().invoke("stopService");
      }
    });
  }

  Future<void> loadPlaylist() async {
    _isLoading = true;
    _error = null;

    try {
      _playlist = await SongService.fetchPlaylist();
      final dir = await getApplicationDocumentsDirectory();

      await Future.wait(
        _playlist.map((song) async {
          final file = File('${dir.path}/${_fileNameForSong(song)}');
          song.isDownloaded = await file.exists();
          if (song.isDownloaded) song.downloadProgress = 1.0;
        }),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> play(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentSongIndex = index;
    final song = _playlist[index];
    String path;

    if (song.isDownloaded) {
      final dir = await getApplicationDocumentsDirectory();
      path = '${dir.path}/${_fileNameForSong(song)}';
    } else {
      path = song.url;
    }

    try {
      final source = AudioSource.uri(
        Uri.parse(path),
        tag: MediaItem(id: song.url, title: song.title, artist: song.author),
      );

      await _audioPlayer.setAudioSource(source);
      await _audioPlayer.play();
    } catch (e) {
      print("Error al reproducir");
    }

    notifyListeners();
  }

  void listenToDuration() {
    _durationSub = _audioPlayer.durationStream.listen((newDuration) {
      if (newDuration != null) {
        _totalDuration = newDuration;
        notifyListeners();
      }
    });

    _positionSub = _audioPlayer.positionStream.listen((newPosition) {
      if ((newPosition - _lastNotifiedPosition).inMilliseconds.abs() >= 500) {
        _currentDuration = newPosition;
        _lastNotifiedPosition = newPosition;
        notifyListeners();
      }
    });

    _playerStateSub = _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void pause() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void resume() {
    _audioPlayer.play();
    notifyListeners();
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      pause();
    } else {
      resume();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  Future<void> playNext() async {
    if (_currentSongIndex < _playlist.length - 1) {
      await play(_currentSongIndex + 1);
    } else {
      _currentSongIndex = 0;
      await play(_currentSongIndex);
    }
  }

  Future<void> playPrevious() async {
    final currentPosition = _audioPlayer.position;

    if (currentPosition > Duration(seconds: 2)) {
      await seek(Duration.zero);
    } else {
      if (_currentSongIndex > 0) {
        await play(_currentSongIndex - 1);
      } else {
        await play(_playlist.length - 1);
      }
    }
  }

  void downloadSong(Song song) {
    final filename = _fileNameForSong(song);
    FlutterBackgroundService().invoke('download', {
      'url': song.url,
      'filename': filename,
    });
  }

  String _fileNameForSong(Song song) {
    return '${song.title.toLowerCase().replaceAll(' ', '_')}.mp3';
  }

  List<Song> get playlist => _playlist;
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentMusic =>
      (_currentSongIndex >= 0 && _currentSongIndex < _playlist.length)
          ? _playlist[_currentSongIndex]
          : null;

  int get currentSongIndex => _currentSongIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  @override
  void dispose() {
    _durationSub.cancel();
    _positionSub.cancel();
    _playerStateSub.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
