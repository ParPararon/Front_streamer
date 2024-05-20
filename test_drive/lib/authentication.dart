import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
TextEditingController _userloginController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _ipController = TextEditingController();

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
          ],
        )
      ),
    );
  }

  void _login() async {
    String userLogin = _userloginController.text;
    String password = _passwordController.text;
    String ip = _ipController.text;

    if(userLogin != '' || password != '' || ip != ''){
      Navigator.pushReplacementNamed(context, '/home');
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