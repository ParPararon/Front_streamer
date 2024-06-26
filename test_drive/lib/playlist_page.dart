import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/cookie_provider.dart';
import 'package:test_drive/providers/ip_provider.dart';
import 'package:test_drive/models/playlist.dart';
import 'package:test_drive/models/song.dart';
import 'package:test_drive/providers/list%3Csong%3E_provider.dart';
import 'app_colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'providers/song_provider.dart';
import 'package:http/http.dart' as http;


class CurrutenPlaylist extends StatefulWidget{

  const CurrutenPlaylist({Key ?key}) : super(key: key);

  @override
  _CurrutenPlaylistState createState() => _CurrutenPlaylistState();

}

class _CurrutenPlaylistState extends State<CurrutenPlaylist>{
  TextEditingController _playlistNameController = TextEditingController();
  final List<String> options = ['Удалить из плейлиста','2','3'];
  String selectedPlaylist = 'Выберите плейлист';
  //List<String> timed =['aaaaa','aaaaa','aaaaa'];
  List<Playlist> playlists = [];
  List<Song> curPlalistSongs = [];
  late Playlist curPlaylist;

  @override
  void initState(){
    super.initState();
    final ipProvider = Provider.of<IpProvider>(context,listen: false);
    final cookieProvider = Provider.of<CookieProvider>(context, listen: false);
    String ip = ipProvider.ip;
    Cookie cookie = cookieProvider.cookie;
    _loadData(cookie, ip);
  }

  

  Future<void> _loadData(Cookie cookie, String ip) async{
    var url = Uri.parse('http://$ip/get_playlists');

    String cookieHeader = '${cookie.name}=${cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };

    var response = await http.get(url,headers: headers);
    if (response.statusCode == 200){
      print(response.headers);
      print(response.body);
  
      List<dynamic> jsonList = json.decode(response.body);
      playlists = jsonList.map((json) => Playlist.fromJson(json)).toList();
      await _loadPlaylistData(playlists.last, cookie, ip);
      setState(() {
        curPlaylist = playlists.last;
        selectedPlaylist = playlists.last.name;
      });
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Не получилось загрузить плейлисты'),
            content: Text('Ну заплачь'),
            actions: <Widget>[
              FloatingActionButton(
                child: Text('Ок'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

  Future<void> _loadPlaylistData(Playlist playlist,Cookie cookie, String ip) async{
    String cookieHeader = '${cookie.name}=${cookie.value}';
    curPlalistSongs.clear();

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };
    for( var element in playlist.songs){
      var url = Uri.parse('http://$ip/fetch/song?id=${element}');
      var response = await http.get(url,headers: headers);
      curPlalistSongs.add(Song.fromJson(json.decode(response.body)));
    };
  }

  Future<void> _deleteSongFromPlaylist(Cookie cookie, String ip, int id) async{
    String cookieHeader = '${cookie.name}=${cookie.value}';
    curPlalistSongs.clear();

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };
    var url = Uri.parse('http://$ip/delete_from_playlist/${curPlaylist.id}/$id');
    var response = await http.delete(url,headers: headers);
    if(response.statusCode != 200){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Не получилось удалить песню'),
            content: Text('Ну заплачь'),
            actions: <Widget>[
              FloatingActionButton(
                child: Text('Ок'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }

  }

  Future<void> _deletePlayList(Cookie cookie, String ip, Playlist playlist) async{
    String cookieHeader = '${cookie.name}=${cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };
    var url = Uri.parse('http://$ip/delete_playlist/${playlist.id}');

    var response = await http.delete(url, headers: headers);
    if (response.statusCode == 200){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Плейлист ${playlist.name} удалён'),
            content: Text('Надеюсь вы не плачете'),
            actions: <Widget>[
              FloatingActionButton(
                child: Text('Ура?'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Плейлист ${playlist.name} не удалён'),
            content: Text('ну заплачте'),
            actions: <Widget>[
              FloatingActionButton(
                child: Text('Ок'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }
  


  @override
  Widget build(BuildContext context){
    Cookie cookie = context.watch<CookieProvider>().cookie;
    String ip = context.watch<IpProvider>().ip;
    
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [

              //Верхняя часть приложения
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                   
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: 
                      Column(
                      children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                      onTap:() {_showPlaylistMenu(context);},
                      child: Text(selectedPlaylist, style: TextStyle(fontSize: 30, color: AppColors.unused_icon)),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Text("Число треков: ${curPlalistSongs.length}", style: TextStyle(fontSize: 15, color: AppColors.unused_icon)),],
                    ),
                    ),

                    //Правая иконка
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white,size: 25,),
                        onPressed: () async{
                          if(curPlaylist.name == playlists.last.name){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('Вы не можете удалить основной плейлист'),
                                  content: Text('Ну заплачь'),
                                  actions: <Widget>[
                                    FloatingActionButton(
                                      child: Text('Ок'),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          }
                          else{
                            await _deletePlayList(cookie, ip, curPlaylist);
                            setState(() {
                              selectedPlaylist = playlists.last.name;
                              curPlaylist = playlists.last;
                            });

                          }
                        },
                      )
                    ),
                  ],
                ),
              ),

              //Линия
              Divider(
                color: AppColors.unused_icon,
                thickness: 2,
                height: 20,
                indent: 30,
                endIndent: 30,
              ),

              //Список песен
              Flexible(
                fit: FlexFit.tight,
                child: 
                ListView.builder(
                  itemCount: curPlalistSongs.length,
                  itemBuilder: (_,i){
                  
                  return GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      print('tap');
                      context.read<SongProvider>().ChangeSong(newSong: curPlalistSongs[i]);
                      context.read<ListSongProvider>().ChangeSong(newListSong: curPlalistSongs);
                    },
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.song_background,
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),

                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 20, left: 10),
                              child: Icon(Icons.music_note_outlined, size: 30, color: AppColors.unused_icon),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(curPlalistSongs[i].name,
                                   style: TextStyle(fontSize: 14, color: AppColors.unused_icon),),
                                ),
                                Container(
                                  child: Text(curPlalistSongs[i].artist, 
                                    style: TextStyle(fontSize: 10, color: AppColors.unused_icon),),
                                ),
                              ],
                            ),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: PopupMenuButton<int>(
                                    iconColor: Colors.white,
                                    itemBuilder: (BuildContext context) =>[
                                      PopupMenuItem<int>(child: Text('Удалить'), value: 1),
                                      PopupMenuItem<int>(child: Text('Добавить в плейлист'), value: 2),
                                    ],
                                    onSelected: (value) async{
                                      switch (value) {
                                        case 1:
                                          await _deleteSongFromPlaylist(cookie, ip, curPlalistSongs[i].id);
                                          await _loadPlaylistData(curPlaylist, cookie, ip);
                                          break;
                                        case 2:

                                          break;
                                      }
                                    },
                                  )
                                ),
                              ],
                            ))
                          ],
                        ),
                        )
                      ),
                  )
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaylistMenu(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            for(var playlist in playlists)
              ListTile(
                
                title: Text(playlist.name),
                onTap: ()async {
                  var ip = Provider.of<IpProvider>(context, listen: false).ip;
                  var cookie = Provider.of<CookieProvider>(context, listen: false).cookie;

                  await _loadPlaylistData(playlist,cookie,ip);
                  setState(() {
                    selectedPlaylist = playlist.name;
                    curPlaylist = playlist;
                  });

                  Navigator.pop(context);
                },
              ),
            ListTile(
              title: Text('Добавить Плейлист'),
              onTap:() {
                Navigator.pop(context);
                _showFormForAdd(context);
              },
            )
          ],
        );
      }
    );
  }

  void _showFormForAdd(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: _playlistNameController,
              decoration: InputDecoration(
                hintText: 'Имя альбома',
                fillColor: AppColors.unused_icon,
                hintStyle: TextStyle(color: AppColors.unused_icon)
                ),
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: (){
                _addPlaylist(_playlistNameController.text);
                Navigator.pop(context);
              },
              
            )
          ],
        );
      }
    );
  }

  void _addPlaylist(String name) async{
    String toSend = '{"Name":"$name"}';
    String ip = Provider.of<IpProvider>(context, listen: false).ip;
    Cookie cookie = Provider.of<CookieProvider>(context, listen: false).cookie;

    String cookieHeader = '${cookie.name}=${cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };

    var url = Uri.parse('http://$ip/add_playlist');
    var response = await http.post(url,body: toSend,headers: headers);
  }
}

