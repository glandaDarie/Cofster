import 'package:flutter/material.dart';

class OrderIDProvider with ChangeNotifier {
  static OrderIDProvider _instance = OrderIDProvider._();

  OrderIDProvider._();

  static OrderIDProvider get instance => _instance;

  String _orderID = null;

  String get orderID => _orderID;

  void set orderID(String newOrderID) {
    _orderID = newOrderID;
    _checkAndNotify();
  }

  void _checkAndNotify() {
    if (_orderID != null) {
      notifyListeners();
    }
  }
}
