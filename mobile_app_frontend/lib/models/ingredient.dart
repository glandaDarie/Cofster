import 'package:flutter/material.dart';

class Ingredient {
  String _ingredientName;
  Icon _ingredientIcon;
  Color _ingredientColor;

  Ingredient(
      String ingredientName, Icon ingredientIcon, Color ingredientColor) {
    this._ingredientName = ingredientName;
    this._ingredientIcon = ingredientIcon;
    this._ingredientColor = ingredientColor;
  }

  String get ingredientName => this._ingredientName;
  Icon get ingredientIcon => this._ingredientIcon;
  Color get ingredientColor => this._ingredientColor;

  void set ingredientName(String _value) => this._ingredientName = _value;
  void set ingredientIcon(Icon _value) => this._ingredientIcon = _value;
  void set ingredientColor(Color _value) => this._ingredientColor = _value;

  @override
  String toString() {
    return "${this._ingredientName} ${this._ingredientIcon} ${this._ingredientColor}";
  }
}
