import 'package:flutter/material.dart';

class CardSwiper {
  BuildContext _context;
  String _imgPath;
  String _coffeeName;
  String _shopName;
  String _description;
  String _price;
  bool _isFavorite;

  CardSwiper(BuildContext context, String imgPath, String coffeeName,
      String shopName, String price,
      [String description, bool isFavorite]) {
    this._context = context;
    this._imgPath = imgPath;
    this._coffeeName = coffeeName;
    this._shopName = shopName;
    this._description = description;
    this._price = price;
    this._isFavorite = isFavorite;
  }

  BuildContext get context => this._context;
  String get imgPath => this._imgPath;
  String get coffeeName => this._coffeeName;
  String get shopName => this._shopName;
  String get description => this._description;
  String get price => this._price;
  bool get isFavorite => this._isFavorite;

  set context(BuildContext _value) => this._context = _value;
  set imgPath(String _value) => this._imgPath = _value.trim();
  set coffeeName(String _value) => this._coffeeName = _value.trim();
  set shopName(String _value) => this._shopName = _value.trim();
  set description(String _value) => this._description = _value.trim();
  set price(String _value) => this._price = _value.trim();
  set isFavorite(bool _value) => this._isFavorite = _value;

  @override
  String toString() {
    return "${this._context} ${this._imgPath} ${this._coffeeName} ${this._shopName} ${this._description} ${this._price} ${this._isFavorite}";
  }
}
