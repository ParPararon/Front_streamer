import 'package:audioplayers/audioplayers.dart';

class AudioService{
  static AudioPlayer _audioPlayer = AudioPlayer();
  static Duration _totalDuration = Duration.zero;
  static Duration _currentPosition = Duration.zero;

  static AudioPlayer get audioPlayer => _audioPlayer; 
  static Duration get totalDuration => _totalDuration;
  static Duration get currentPosition => _currentPosition;

  static void initialize(){
    _audioPlayer.onDurationChanged.listen((duration) { 
      _totalDuration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) { 
      _currentPosition = position;
    });
  }

  static Future<void> stop() async {
    await _audioPlayer.pause();
  }

  static Future<void> loop() async{
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  static Future<void> unloop() async{
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  static Future<void> play(String url) async{
    await _audioPlayer.play(UrlSource(url));
  }

  static Future<void> resume() async{
    await _audioPlayer.resume();
  }

  static Future<void> release() async{
    await _audioPlayer.release();
  }

  static Future<void> changeTime(int seconds) async{
    Duration newDuration = Duration(seconds: seconds);
    await _audioPlayer.seek(newDuration);
  }

}