import 'package:flutter/material.dart';

class UpdateProvider extends ChangeNotifier {
  void triggerUpdate() {
    notifyListeners();
  }
}
