import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/drinkMadeByOrderType.dart' show OrderType;

class MergeNotifiers {
  final int quantity;
  final String selectedValue;
  final OrderType orderType;
  final int sugarQuantity;
  final int iceQuantity;
  final int creamNotifier;

  MergeNotifiers(this.quantity, this.selectedValue, this.orderType,
      this.sugarQuantity, this.iceQuantity, this.creamNotifier);
}

class ValueNotifierService<T> extends ValueNotifier<T> {
  ValueNotifierService(T value) : super(value);
}
