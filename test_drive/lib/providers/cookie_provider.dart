import 'dart:io';
import 'package:flutter/material.dart';

class CookieProvider extends ChangeNotifier{
  Cookie cookie = new Cookie("", "");



  void ChangeCookie({
    required Cookie newCookie
  }) async{
    cookie = newCookie;
    notifyListeners();
  }
}