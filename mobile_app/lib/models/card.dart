import 'package:flutter/material.dart';

class CoffeeCard {
  String _imgPath;
  String _coffeeName;
  String _shopName;
  String _description;
  String _price;
  ValueNotifier<bool> _isfavoriteNotifier;
  BuildContext _context;
  int _index;

  CoffeeCard(String imgPath, String coffeeName, String shopName, String price,
      [String description,
      bool isFavoriteNotifier,
      BuildContext context,
      int index]) {
    this._imgPath = imgPath;
    this._coffeeName = coffeeName;
    this._shopName = shopName;
    this._description = description;
    this._price = price;
    this._isfavoriteNotifier = ValueNotifier<bool>(isFavoriteNotifier);
    this._context = context;
    this._index = index;
  }

  String get imgPath => this._imgPath;
  String get coffeeName => this._coffeeName;
  String get shopName => this._shopName;
  String get description => this._description;
  String get price => this._price;
  ValueNotifier<bool> get isFavoriteNotifier => this._isfavoriteNotifier;
  BuildContext get context => this._context;
  int get index => this._index;

  set imgPath(String _value) => this._imgPath = _value.trim();
  set coffeeName(String _value) => this._coffeeName = _value.trim();
  set shopName(String _value) => this._shopName = _value.trim();
  set description(String _value) => this._description = _value.trim();
  set price(String _value) => this._price = _value.trim();
  set isFavoriteNotifier(ValueNotifier<bool> _value) =>
      this.isFavoriteNotifier = _value;
  set context(BuildContext _value) => this._context = _value;
  set index(int _value) => this._index = _value;

  @override
  String toString() {
    return "${this._imgPath} ${this._coffeeName} ${this._shopName} ${this._description} ${this._price} ${this._isfavoriteNotifier} ${this._context} ${index}";
  }
}
