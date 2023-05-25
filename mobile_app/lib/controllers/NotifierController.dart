import 'package:flutter/material.dart';

class MergedNotifierService {
  final int quantity;
  final String selectedValue;

  MergedNotifierService(this.quantity, this.selectedValue);
}

class ValueNotifierCustomDrinkSelectorService<T> extends ValueNotifier<T> {
  ValueNotifierCustomDrinkSelectorService(T value) : super(value);
}
