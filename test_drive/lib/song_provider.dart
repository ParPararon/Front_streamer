import 'package:flutter/material.dart';
import 'song.dart';

class SongProvider extends ChangeNotifier{
  Song song = Song("", "");


  void ChangeSong({
    required Song newSong
  }) async{
    song = newSong;
    notifyListeners();
  }
}