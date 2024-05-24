import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/ip_provider.dart';
import 'package:test_drive/main.dart';
import 'app_colors.dart' as AppColors;
import 'models/login.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'providers/cookie_provider.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
TextEditingController _userloginController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _ipController = TextEditingController();
late Login login;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Здраствуйте',style: TextStyle(fontSize: 30,color: AppColors.unused_icon),),
            Container(
              margin: EdgeInsetsDirectional.only(top: 25),
              width: 300,
              height: 35,
              child: TextField(
                style: TextStyle(color: AppColors.unused_icon),
                controller: _userloginController,
                decoration: InputDecoration(
                  hintText: 'Логин',
                  fillColor: AppColors.unused_icon,
                  hintStyle: TextStyle(color: AppColors.unused_icon)
                  ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              width: 300,
              height: 35,
              child: TextField(
                style: TextStyle(color: AppColors.unused_icon),
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  fillColor: AppColors.unused_icon,
                  hintStyle: TextStyle(color: AppColors.unused_icon)
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: 300,
              height: 35,
              child: TextField(
                style: TextStyle(color: AppColors.unused_icon),
                controller: _ipController,
                decoration: InputDecoration(
                  hintText: 'IP',
                  fillColor: AppColors.unused_icon,
                  hintStyle: TextStyle(color: AppColors.unused_icon)
                ),
              ),
            ),
            Container(
              child: TextButton(
                child: Text('Войти',style: TextStyle(fontSize: 20,color: AppColors.unused_icon),),
                onPressed: () {
                  _login();
                },
              ),
            ),

            TextButton(
              child: Text('Кнопка для Паши'),
              onPressed: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicPage()));
              },
            )
          ],
        )
      ),
    );
  }

  void _login() async {
    String userLogin = _userloginController.text;
    String password = _passwordController.text;

    var ip = _ipController.text;
    var url = Uri.parse('http://$ip/login');

    login = Login(login: userLogin, password: password);
    String json = jsonEncode(login);

    var response = await http.post(url, body: json);
    print(json);
    print(response.headers['set-cookie']);

    if(response.statusCode == 200){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicPage()));
      var parsedCookie = Cookie.fromSetCookieValue(response.headers['set-cookie']!);
      context.read<CookieProvider>().ChangeCookie(newCookie: parsedCookie);
      context.read<IpProvider>().ChangeIp(newIp: ip);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Вход не выполнен'),
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
}