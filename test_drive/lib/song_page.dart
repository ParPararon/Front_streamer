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
  
  @override
  void initState(){
    super.initState();

  }
  List<Song> playList = [];
  int currentIndex = 0;
  
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
          height: _isExpanded ? MediaQuery.of(context).size.height: 100,
          color: Colors.grey,
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
                    
                    Text(playList.isNotEmpty ? playList[currentIndex].name : 'Идёт загрузка'),
                    Text(playList.isNotEmpty ? playList[currentIndex].artist : 'Идёт загрузка'),
                    Text(playList.isNotEmpty ? playList[currentIndex].album : 'Идёт загрузка'),
                    
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
                                  '${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}'
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
                        IconButton(
                          icon: Icon(Icons.skip_previous_rounded,size: 50,),
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
                          icon: _isPlaying ? Icon(Icons.pause_rounded,size: 50,): Icon(Icons.play_arrow_rounded,size: 50),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next_rounded,size: 50,),
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
                      ],
                    )
                    
                  ],
                ),
                
              ),
              
              Visibility(
                visible: !_isExpanded,
                child: Column(
                  children: [
                    if (context.watch<SongProvider>().song.id == 0)
                    Text('Вы ещё не выбрали песню', style: TextStyle(color: Colors.white),)
                    else
                    Text(context.watch<SongProvider>().song.name, style: TextStyle(color: Colors.white),)
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