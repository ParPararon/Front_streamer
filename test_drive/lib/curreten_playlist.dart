import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'app_colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'song_provider.dart';


class CurrutenPlaylist extends StatefulWidget{
  const CurrutenPlaylist({Key ?key}) : super(key: key);

  @override
  _CurrutenPlaylistState createState() => _CurrutenPlaylistState();

}

class _CurrutenPlaylistState extends State<CurrutenPlaylist>{
  final List<String> options = ['1','2','3'];

  @override
  Widget build(BuildContext context){
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

                    //Левая Иконка
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon),
                    ),

                    //Текст по центру
                    //ВНИМАНИЕ ВНИМАНИЕ ТУТ ДИНАМИЧЕСКИЕ ДАННЫЕ ИСПРАВЬ
                    Column(
                      children: [
                        Container(
                          child: Text("Ваши треки", style: TextStyle(fontSize: 25, color: AppColors.unused_icon)),
                        ),
                        Container(
                          child: Text("10 треков", style: TextStyle(fontSize: 15, color: AppColors.unused_icon)),
                        )
                      ],
                    ),

                    //Правая иконка
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Icon(Icons.settings, size: 30 ,color: AppColors.unused_icon),
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

                        child:  Row(
                          
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
                        )
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