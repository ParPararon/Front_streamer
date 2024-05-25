import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/audio_service.dart';
import 'package:test_drive/models/playlist.dart';
import 'package:test_drive/models/song.dart';
import 'package:test_drive/providers/list%3Csong%3E_provider.dart';
import 'package:test_drive/providers/song_provider.dart';
import 'package:http/http.dart' as http;


class SongPage extends StatefulWidget{
  final Cookie cookie;
  final String ip;
  const SongPage({Key ?key, required this.cookie, required this.ip}) :super (key: key);
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>{
  bool _isExpanded = false;
  bool _isPlaying = false;
  bool _isLooped = false;
  
  @override
  void initState(){
    super.initState();

  }
  List<Song> playList = [];
  int currentIndex = 0;

  void _radio(int id ) async{
    var url = Uri.parse('http://${this.widget.ip}/radio/${id}');

    String cookieHeader = '${this.widget.cookie.name}=${this.widget.cookie.value}';

    final headers = {
      'Conten-Type': 'application/json',
      'Cookie': cookieHeader,
    };

    var response = await http.get(url,headers: headers);
    if(response.statusCode == 200){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Запрос отработал'),
            content: Text('Но функционала нет(((('),
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
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Не вышло'),
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
    return GestureDetector(
        onTap: () {
          if(_isExpanded == false){
            playList = Provider.of<ListSongProvider>(context, listen: false).listSong; 
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: _isExpanded ? MediaQuery.of(context).size.width: 500,
          height: _isExpanded ? MediaQuery.of(context).size.height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            color: Color.fromARGB(255, 23, 22, 22)
          ),
          child: Column(
            children: [
              Visibility(
                visible: _isExpanded,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: (){
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      }, 
                      icon: Icon(Icons.arrow_back_ios_sharp,size: 50,)
                    ),

                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.all(10),

                      child: Center(
                        child: Icon(Icons.library_music_outlined, color: Colors.white,size: 70,),
                      ),
                      
                    ),
                    
                    Text(playList.isNotEmpty ? playList[currentIndex].name : 'Идёт загрузка', style: TextStyle(color: Colors.white,fontSize: 25),),
                    Text(playList.isNotEmpty ? playList[currentIndex].artist : 'Идёт загрузка', style: TextStyle(color: Colors.white,fontSize: 17)),
                    Text(playList.isNotEmpty ? playList[currentIndex].album : 'Идёт загрузка',style: TextStyle(color: Colors.white,fontSize: 15),),
                    
                    StreamBuilder<Duration>(
                      stream: AudioService.audioPlayer.onPositionChanged,
                      builder: (context,snapshot){
                        final currentPosition = snapshot.data ?? Duration.zero;
                        return StreamBuilder<Duration>(
                          stream: AudioService.audioPlayer.onDurationChanged,
                          builder: (context, snapshot) {
                            final totalDuration = snapshot.data ?? Duration.zero;
                            return Column(
                              children: [
                                Slider(
                                  activeColor: Colors.green[900],
                                  min: 0,
                                  max: totalDuration.inSeconds.toDouble(),
                                  value: currentPosition.inSeconds.toDouble().clamp(0, totalDuration.inSeconds.toDouble(),),
                                  onChanged: (value) {
                                    setState(() {
                                      AudioService.changeTime(value.toInt());
                                    });
                                  },
                                ),
                                Text(
                                  '${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}', style: TextStyle(color: Colors.white, fontSize: 15),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //зацикливание
                        IconButton(
                          icon: Icon(Icons.loop_rounded,size: 50,color: _isLooped ? Colors.green[900]: Colors.white,),
                          onPressed: () {
                            if(_isLooped == true){
                              AudioService.loop();
                              setState(() {
                                _isLooped = !_isLooped;
                              });
                            }
                            else{
                              AudioService.unloop();
                              setState(() {
                                _isLooped = !_isLooped;
                              });
                            }
                          },
                        ),

                        //Предыдущий трек
                        IconButton(
                          icon: Icon(Icons.skip_previous_rounded,size: 50, color: Colors.white,),
                          onPressed: () {
                            if(currentIndex - 1 != -1){
                              setState(() {
                                currentIndex -=1;
                              });
                              AudioService.play('http://${this.widget.ip}/play/${playList[currentIndex].id}');
                            }
                            else{
                              AudioService.release();
                              AudioService.play('http://${this.widget.ip}/play/${playList[currentIndex].id}');
                            }
                          },
                        ),
                        //Старт/Пауза
                        IconButton(
                          onPressed: (){
                            if(_isPlaying == false){
                              if(playList.length == 0){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Произошла какая-то ошибка...'),
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
                                AudioService.play('http://${this.widget.ip}/play/${playList[currentIndex].id}');
                              }
                            }
                            else{
                              AudioService.stop();
                            }
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: _isPlaying ? Icon(Icons.pause_rounded,size: 50, color: Colors.white,): Icon(Icons.play_arrow_rounded,size: 50, color: Colors.white,),
                        ),

                        //Следующий трек
                        IconButton(
                          icon: Icon(Icons.skip_next_rounded,size: 50, color: Colors.white,),
                          onPressed: (){
                            if(currentIndex == playList.length -1){
                              AudioService.release();
                              AudioService.play('http://${this.widget.ip}/play/${playList[currentIndex].id}');
                            }
                            else{
                              setState(() {
                                currentIndex +=1;
                              });
                              AudioService.play('http://${this.widget.ip}/play/${playList[currentIndex].id}');
                            }
                          },
                        ),

                        //Радио
                        IconButton(
                          icon: Icon(Icons.radar, size: 50, color: Colors.white,),
                          onPressed: () {
                            _radio(playList[currentIndex].id);
                          },
                        ),


                      ],
                    )
                    
                  ],
                ),
                
              ),
              
              Visibility(
                visible: !_isExpanded,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    if (context.watch<SongProvider>().song.id == 0)
                    Container(
                      child: Center(
                        child: Text('Вы ещё не выбрали песню', style: TextStyle(color: Colors.white, fontSize: 20),),
                      ),
                    )
                    else
                      Text(context.watch<SongProvider>().song.name, style: TextStyle(color: Colors.white,fontSize: 20),),
                      Text(context.watch<SongProvider>().song.artist, style: TextStyle(color: Colors.white, fontSize: 15),)
                  ],
                )
                  
                )
          ],
          ),
        ),
      );

    
    
  }
}

String formatDuration(Duration duration){
  String twoDigits(int n) => n.toString().padLeft(2,"0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours,minutes,seconds].join(':');
}