import 'package:flutter/material.dart';
import '../models/song.dart';

class ListSongProvider extends ChangeNotifier{
  List<Song> listSong = [];



  void ChangeSong({
    required List<Song> newListSong
  }) async{
    listSong = newListSong;
    notifyListeners();
  }
}