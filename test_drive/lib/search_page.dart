import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/models/playlist.dart';
import 'package:test_drive/providers/cookie_provider.dart';
import 'package:test_drive/providers/ip_provider.dart';
import 'package:test_drive/models/song.dart';
import 'package:test_drive/providers/playlist_provider.dart';
import 'package:test_drive/providers/song_provider.dart';
import 'app_colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MyHomePage extends StatefulWidget{

  const MyHomePage({Key ?key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
  

}

class _MyHomePageState extends State<MyHomePage>{
  TextEditingController _inputTextController = TextEditingController();
  final List<String> options = ['1','2','3'];
  bool _isDataLoaded = false;
  List<Song> _dataList = [];
  int _selectedButtonIndex = 0;
  Playlist search = Playlist(id: -1, user_id: -1, name: 'search', songs: []);

  void _loadData(String ip, Cookie cookie, int index, String input) async {
    var url = Uri.parse('http://$ip/fetch/all');

    String cookieHeader = '${cookie.name}=${cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };

    var response = await http.get(url,headers: headers);
    List<dynamic> jsonList = json.decode(response.body);

    _dataList = jsonList.map((json) => Song.fromJson(json)).toList();

    if(index == 0){
      if(input == ""){
      }
      else{
        for(int i = 0; i < _dataList.length;i++){
          if(!(_dataList[i].name.contains(input) || _dataList[i].artist.contains(input) || _dataList[i].album.contains(input))){
            _dataList.removeAt(i);
          }
        }
      }
    }
    else if(index  == 1){
      for(int i = 0; i < _dataList.length;i++){
        if(!(_dataList[i].name.contains(input))){
          _dataList.removeAt(i);
        }
      }
    }
    else if(index  == 2){
      for(int i = 0; i < _dataList.length;i++){
        if(!(_dataList[i].artist.contains(input))){
          _dataList.removeAt(i);
        }
      }
    }
    else if(index  == 3){
      for(int i = 0; i < _dataList.length;i++){
        if(!(_dataList[i].album.contains(input))){
          _dataList.removeAt(i);
        }
      }
    }
    _dataList.forEach((element) {
      search.songs!.add(element.id);
    },);

    setState(() {
      _isDataLoaded = true;
    });
  }

  void _addSong(String ip,Cookie cookie, int id) async{
    var url = Uri.parse('http://$ip/add_to_playlist/1/$id');

    String cookieHeader = '${cookie.name}=${cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };

    var response = await http.post(url,headers: headers);

    if(response.statusCode == 200){

    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Не получилось добавить песню'),
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
  
  @override
  Widget build(BuildContext context){
    String ip = context.watch<IpProvider>().ip;
    Cookie cookie = context.watch<CookieProvider>().cookie;

    return Container(
      
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            
            children: [
              // Иконка меню
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20,top: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon)
              ]),
              ),
              // Текст Поиск
              Row(
                children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Text("Поиск", style: TextStyle(fontSize: 35, color: AppColors.unused_icon),),
                )],
              ),
              //Строка Поиска
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: _inputTextController,
                  onChanged: (value) {
                    setState(() {
                      _isDataLoaded = false;
                    });
                  },
                  onSubmitted: (value) {
                    _loadData(ip,cookie, _selectedButtonIndex, _inputTextController.text);
                  },
                  style: TextStyle(color: AppColors.unused_icon),
                  decoration: InputDecoration(
                    hintText: 'Название Песни', 
                    hintStyle: TextStyle(color: AppColors.unused_icon), 
                    fillColor: AppColors.song_background),
                  ),
                ),
              //Кнопки для сортировки
              Container(
                margin: EdgeInsets.only(top: 10),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () { _handleButtonSelection(0);},
                            child: Text('Всё', style: TextStyle(color: AppColors.unused_icon)),
                            style: _selectedButtonIndex == 0 ? ElevatedButton.styleFrom(backgroundColor: Colors.green[500]) : 
                            ElevatedButton.styleFrom(backgroundColor: AppColors.song_background),
                            ),
                          ElevatedButton(
                            onPressed: () { _handleButtonSelection(1);},
                            child: Text('Название',style: TextStyle(color: AppColors.unused_icon)),
                            style: _selectedButtonIndex == 1 ? ElevatedButton.styleFrom(backgroundColor: Colors.green[500]) : 
                            ElevatedButton.styleFrom(backgroundColor: AppColors.song_background),
                            ),
                          ElevatedButton(
                            onPressed: () { _handleButtonSelection(2);},
                            child: Text('Автор', style: TextStyle(color: AppColors.unused_icon)),
                            style: _selectedButtonIndex == 2 ? ElevatedButton.styleFrom(backgroundColor: Colors.green[500]) : 
                            ElevatedButton.styleFrom(backgroundColor: AppColors.song_background),
                            ),
                          ElevatedButton(
                            onPressed: () { _handleButtonSelection(3);},
                            child: Text('Альбом', style: TextStyle(color: AppColors.unused_icon)),
                            style: _selectedButtonIndex == 3 ? ElevatedButton.styleFrom(backgroundColor: Colors.green[500]) : 
                            ElevatedButton.styleFrom(backgroundColor: AppColors.song_background),
                            ),
                        ],
                      ),
                    )
                  ],
                ), 
              ),
              //Текст результатов
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 25),
                    child: Text("Результаты", style: TextStyle(fontSize: 35, color: AppColors.unused_icon),),
                  )
                ],
              ),
              //Линия под результатом
              Divider(
                color: AppColors.unused_icon,
                thickness: 2,
                height: 20,
                indent: 30,
                endIndent: 30,
              ),
              //Список песен
              _isDataLoaded
              
              ?Flexible(
                fit: FlexFit.tight,
                child: 
                ListView.builder(
                  itemCount: _dataList.length,
                  itemBuilder: (_,i){
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.song_background,
                        borderRadius: BorderRadius.circular(10),

                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: (){
                            context.watch<PlayListProvider>().ChangeSong(newPlaylist: search);
                            context.watch<SongProvider>().ChangeSong(newSong: _dataList[i]);
                          },
                        
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
                                    child: Text(_dataList[i].name,
                                    style: TextStyle(fontSize: 16, color: AppColors.unused_icon),),
                                  ),
                                  Container(
                                    child: Text(_dataList[i].artist, 
                                      style: TextStyle(fontSize: 11, color: AppColors.unused_icon),),
                                  ),
                                ],
                              ),
                              Expanded(child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: 
                                    IconButton(
                                      icon: Icon(Icons.add,color: AppColors.unused_icon,size: 30,),
                                      onPressed: (){
                                        _addSong(ip, cookie, _dataList[i].id);
                                    },
                                  ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      icon: Icon(Icons.more_vert,color: AppColors.unused_icon, size: 30,),
                                      onPressed: (){
                                        showModalBottomSheet(
                                          context: context, 
                                          builder: (BuildContext context){
                                            return Container(
                                              height: 200,
                                              color: AppColors.song_background,
                                              child: ListView(
                                                
                                                children: options.map((String option){
                                                  return Container(
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: AppColors.background,
                                                    ),

                                                    child:ListTile(
                                                      tileColor: AppColors.background,
                                                      textColor: AppColors.unused_icon,
                                                      title: Text(option),
                                                      onTap: (){
                                                        Navigator.pop(context,option);
                                                      },
                                                  ),);
                                                }

                                                ).toList(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),



                      ),
                    ),
                  );
                }),
              )

              :Flexible(
                fit: FlexFit.tight,
                child: Center(
                  child: Text(
                    'Тут пока ничего нет ((((',
                    style: TextStyle(color: AppColors.unused_icon, fontSize: 25),),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  void _handleButtonSelection(int index){
    setState(() {
      _selectedButtonIndex = index;
    });
  }
}

