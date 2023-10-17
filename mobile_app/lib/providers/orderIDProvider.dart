import 'package:flutter/material.dart';

class OrderIDProvider with ChangeNotifier {
  static OrderIDProvider _instance = OrderIDProvider._();

  OrderIDProvider._();

  static OrderIDProvider get instance => _instance;

  String _orderID = null;
  Map<String, dynamic> _orderData = null;

  String get orderID => _orderID;

  Map<String, dynamic> get orderData => _orderData;

  void set orderID(String newOrderID) {
    _orderID = newOrderID;
    _checkAndNotify();
  }

  void set orderData(Map<String, dynamic> newOrderData) {
    _orderData = newOrderData;
    _checkAndNotify();
  }

  void _checkAndNotify() {
    if (_orderID != null && _orderData != null) {
      notifyListeners();
    }
  }
}
