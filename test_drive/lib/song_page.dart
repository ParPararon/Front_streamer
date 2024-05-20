import 'package:flutter/material.dart';

class SongPage extends StatefulWidget{
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage>{
  bool isExpanded = false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Visibility(
        visible: isExpanded,
        child: Column(
        ),
      )
      
    );
  }
}