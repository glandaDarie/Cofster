import 'package:flutter/material.dart';

class MergeNotifiers {
  final int quantity;
  final String selectedValue;
  final int sugarQuantity;
  final int iceQuantity;
  final int creamNotifier;

  MergeNotifiers(this.quantity, this.selectedValue, this.sugarQuantity,
      this.iceQuantity, this.creamNotifier);
}

class ValueNotifierService<T> extends ValueNotifier<T> {
  ValueNotifierService(T value) : super(value);
}
