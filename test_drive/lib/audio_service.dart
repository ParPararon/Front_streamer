import 'package:just_audio/just_audio.dart';

class AudioService{
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static Duration _totalDuration = Duration.zero;
  static Duration _currentPosition = Duration.zero;

  static AudioPlayer get audioPlayer => _audioPlayer; 
  static Duration get totalDuration => _totalDuration;
  static Duration get currentPosition => _currentPosition;

  static Future<void> initialize() async {
    _audioPlayer.durationStream.listen((duration) { 
      _totalDuration = duration ?? Duration.zero;
    });

    _audioPlayer.positionStream.listen((position) { 
      _currentPosition = position;
    });
  }

  static Future<void> stop() async {
    await _audioPlayer.pause();
  }

  static Future<void> loop() async{
    await _audioPlayer.setLoopMode(LoopMode.one);
  }

  static Future<void> unloop() async{
    await _audioPlayer.setLoopMode(LoopMode.off);
  }

  static Future<void> play(String url) async{
    try{
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    }
    catch(e){
      print("Error playing audio: $e");
    }
  }

  static Future<void> resume() async{
    await _audioPlayer.play();
  }

  static Future<void> release() async{
    await _audioPlayer.stop();
  }

  static Future<void> changeTime(int seconds) async{
    Duration newDuration = Duration(seconds: seconds);
    await _audioPlayer.seek(newDuration);
  }

}