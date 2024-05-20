import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'app_colors.dart' as AppColors;
import 'package:flutter/material.dart';

class Playlists extends StatefulWidget{
  const Playlists({Key ?key}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();

}

class _PlaylistsState extends State<Playlists>{
  final List<String> options = ['1','2','3'];
  @override
  Widget build(BuildContext context){
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [

              //Текст
              Container(
                child: Text("Ваши Плейлисты", style: TextStyle(fontSize: 25, color: AppColors.unused_icon)),
              ),

              //Ряд Иконок
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40,bottom: 10, top: 10),
                    child: Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon),
                  ),
                  Container(
                    //margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon),
                  )
                ],
              ),

              //Лист Плейлистов
              Container(
                height: 300,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: 5,
                  itemBuilder: (_,i){
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 160,
                            width: 160  ,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.song_background,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(Icons.queue_music_outlined,size: 70,color: AppColors.unused_icon,),
                                Container(
                                  margin: EdgeInsets.only(left: 40,right: 20),
                                  child :Text('Название плейлиста',style: TextStyle(color: AppColors.unused_icon,fontSize: 15), ) 
                                ),
                              ],
                            ),

                          ),
                          Container(
                            margin: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.song_background,
                            ),
                            height: 70,
                            width: 500,
                            
                              child: Text("Описание",style: TextStyle(color: AppColors.unused_icon,fontSize: 20),),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
              //Описание Плейлиста(ДИНАМИЧЕСКИ)
              Container(),

              //Текст
              Container(
                child: Text("Список треков", style: TextStyle(fontSize: 20, color: AppColors.unused_icon)),
              ),
  
              //Линия
              Divider(
                color: AppColors.unused_icon,
                thickness: 2,
                height: 20,
                indent: 30,
                endIndent: 30,
              ),

              //Список песен(ДИНАМИЧЕСКИ)
              Flexible(
                fit: FlexFit.tight,
                child: 
                ListView.builder(
                  itemCount: 20,
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
                                  child: Text('Название песни',
                                   style: TextStyle(fontSize: 16, color: AppColors.unused_icon),),
                                ),
                                Container(
                                  child: Text('Имя исполнителя', 
                                    style: TextStyle(fontSize: 11, color: AppColors.unused_icon),),
                                ),
                              ],
                            ),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                  );
                }),
              )
            
            ],
          ),
        ),
      ),
    );
  }
}