import 'package:flutter/material.dart';
import '../models/playlist.dart';

class PlayListProvider extends ChangeNotifier{
  Playlist playlist= Playlist(id: -1, user_id: -1, name: "", songs: []);
  

  void ChangeSong({
    required Playlist newPlaylist
  }) async{
    playlist = newPlaylist;
    notifyListeners();
  }
}