import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'app_colors.dart' as AppColors;
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget{
  const MyHomePage({Key ?key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage>{
  final List<String> options = ['1','2','3'];
  bool _isDataLoaded = false;
  List<String> _dataList = [];

  void _loadData() {
    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        _dataList = List.generate(10, (index) => 'Трек $index');
        _isDataLoaded = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context){
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
                  onChanged: (value) {
                    _isDataLoaded = false;
                  },
                  onSubmitted: (value) {
                    _loadData();
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
                    ButtonSelection(),
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
                                  child: Text(_dataList[i],
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
                                  child: 
                                  IconButton(
                                    icon: Icon(Icons.add,color: AppColors.unused_icon,size: 30,),
                                    onPressed: (){},),
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
}

class ButtonSelection extends StatefulWidget{
  @override
  _ButtonSelectionState createState() => _ButtonSelectionState();
}

class _ButtonSelectionState extends State<ButtonSelection>{
  int _selectedButtonIndex = 0;
  @override
  Widget build(BuildContext context){
    return Container(
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
    );
  }

  void _handleButtonSelection(int index){
    setState(() {
      _selectedButtonIndex = index;
    });
  }
}