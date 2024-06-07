
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class AudioService {
  static AudioPlayer _audioPlayer = AudioPlayer();
  static AudioPlayer _preloadedPlayer = AudioPlayer();
  static Duration _totalDuration = Duration.zero;
  static Duration _currentPosition = Duration.zero;

  static List<String> _parsedSong = [];
  static int _curSegIndex = 0;
  static String? _nextSegUrl;

  static AudioPlayer get audioPlayer => _audioPlayer;
  static Duration get totalDuration => _totalDuration;
  static Duration get currentPosition => _currentPosition;

  static Future<void> initialize() async {
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _handlePlaybackComplete();
    });

    _preloadedPlayer.onPlayerComplete.listen((event) {
      _handlePlaybackComplete();
    });
  }

  static Future<void> stop() async {
    await _audioPlayer.pause();
    await _preloadedPlayer.pause();
  }

  static Future<void> loop() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> unloop() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  static Future<void> _play(String url) async {
    try {
      if (_nextSegUrl != null && _nextSegUrl == url) {
        await _audioPlayer.stop();
        await _preloadedPlayer.resume();
        _swapPlayers();
      } else {
        await _audioPlayer.play(UrlSource(url));
      }

      await _preloadNextSeg();
      print("Audio playback started");
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  static Future<void> _preloadNextSeg() async {
    String? nextUrl = (_curSegIndex < _parsedSong.length - 1)
        ? _parsedSong[_curSegIndex + 1]
        : null;
    if (nextUrl != null) {
      try {
        await _preloadedPlayer.setSourceUrl(nextUrl);
        await _preloadedPlayer.pause();
        _nextSegUrl = nextUrl;
        print("Preloaded next segment: $nextUrl");
      } catch (e) {
        print("Error preloading next segment: $e");
      }
    }
  }

  static void _swapPlayers() {
    final tempPlayer = _audioPlayer;
    _audioPlayer = _preloadedPlayer;
    _preloadedPlayer = tempPlayer;
  }

  static Future<void> _handlePlaybackComplete() async {
    if (_curSegIndex < _parsedSong.length - 1) {
      _curSegIndex++;
      await _play(_parsedSong[_curSegIndex]);  // Empty IP, assuming _parsedSong has full URL
    }
  }

  static Future<void> play(String url, String ip) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final content = response.body;
      final lines = LineSplitter.split(content).toList();
      _parsedSong = lines
          .where((line) => line.isNotEmpty && !line.startsWith('#'))
          .toList();
      for(int i = 0; i< _parsedSong.length; i++){
        _parsedSong[i] = 'http://$ip${_parsedSong[i]}';
        print(_parsedSong[i]);
      }

      _curSegIndex = 0;
      await _play(_parsedSong[_curSegIndex]);
    }
  }

  static Future<void> resume() async {
    await _audioPlayer.resume();
  }

  static Future<void> release() async {
    await _audioPlayer.release();
    await _preloadedPlayer.release();
  }

  static Future<void> changeTime(int seconds) async {
    Duration newDuration = Duration(seconds: seconds);
    await _audioPlayer.seek(newDuration);
  }
}