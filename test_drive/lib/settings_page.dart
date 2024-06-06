import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key ?key}) :super (key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          IconButton(
            icon: Icon(Icons.arrow_back_rounded,size: 35,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          Text('Аккаунт',style: TextStyle(color: Colors.white,fontSize: 25),),
          Text('Сменить пользователя',style: TextStyle(color: Colors.white,fontSize: 20),),

          Text('Управление Песнями',style: TextStyle(color: Colors.white,fontSize: 25),),
          Text('Добавить песню',style: TextStyle(color: Colors.white,fontSize: 20),),

        ],
      ),
    );
  }

}