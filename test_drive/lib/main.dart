//import 'dart:html';

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'curreten_playlist.dart';
import 'playlists.dart';
import 'authentication.dart';
import 'package:provider/provider.dart';
import 'song.dart';
import 'song_provider.dart';
import 'song_page.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SongProvider(),
        )
      ],

    child: MaterialApp(
      routes: {
        '/home' :(context) => BasicPage(),
      },
      title: 'Streamer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      
    )
    );
  }
}

class BasicPage extends StatefulWidget{
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage>{
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    CurrutenPlaylist(),
    Playlists(),
  ];

    void _onItemTap(int index){
      setState(() {
        _selectedIndex = index;
      });
    }

    

    @override
    Widget build(BuildContext context){
      
      return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex)
          ),
          
          
          bottomSheet: Container(
            height: 100,
            child: Column(
              children: [
                if(context.watch<SongProvider>().song == Song("",""))
                Container()
                else
                Container(
                  height: 100,
                  child: Center(
                    child: Text('хуй'),
                  ),
                )
              ],
            ),
          ),
          
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.white,
            items: 
              const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Поиск',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note_outlined),
                  label: 'Ваша музыка',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  label: 'Плейлисты',
                ),
              ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          ),
      );
      
    }
}


