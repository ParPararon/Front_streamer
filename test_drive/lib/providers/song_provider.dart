import 'package:flutter/material.dart';
import '../models/song.dart';

class SongProvider extends ChangeNotifier{
  Song song = Song(id: 0, name: "none", artist: "none", album: "none", path: "none");



  void ChangeSong({
    required Song newSong
  }) async{
    song = newSong;
    notifyListeners();
  }
}