import 'package:flutter/material.dart';

class TestScreenProvider extends ChangeNotifier {
  bool flag;

  TestScreenProvider({this.flag = false});

  void changeFlag() {
    this.flag = !this.flag;
    notifyListeners();
  }
}
