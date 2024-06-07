import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_drive/audio_service.dart';
import 'package:test_drive/providers/list%3Csong%3E_provider.dart';
import 'package:test_drive/providers/playlist_provider.dart';
import 'search_page.dart';
import 'playlist_page.dart';
import 'authentication_page.dart';
import 'package:provider/provider.dart';
import 'providers/song_provider.dart';
import 'song_page.dart';
import 'providers/cookie_provider.dart';
import 'providers/ip_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
  await AudioService.initialize();
  }
  catch(e){
    print(e);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SongProvider()),
        ChangeNotifierProvider(create: (context) => CookieProvider()),
        ChangeNotifierProvider(create: (context) => IpProvider()),
        ChangeNotifierProvider(create: (context) => PlayListProvider()),
        ChangeNotifierProvider(create: (context) => ListSongProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Streamer',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: LoginPage(),
    );
  }
}


class BasicPage extends StatefulWidget{
  const BasicPage({Key ?key}) :super (key: key);
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage>{
  int _selectedIndex = 0;


  List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    CurrutenPlaylist(),
  ];

    void _onItemTap(int index){
      setState(() {
        _selectedIndex = index;
      });
    }

    

    @override
    Widget build(BuildContext context){
      Cookie cookie = context.watch<CookieProvider>().cookie;
      String ip = context.watch<IpProvider>().ip;
      
      return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex)
          ),
          
          bottomSheet:SongPage(cookie: cookie, ip: ip),
          
          
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
              ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          ),
      );
      
    }
}


