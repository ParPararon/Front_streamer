import 'package:flutter/material.dart';

class IpProvider extends ChangeNotifier{
  String ip = '';



  void ChangeIp({
    required String newIp
  }) async{
    ip= newIp;
    notifyListeners();
  }
}