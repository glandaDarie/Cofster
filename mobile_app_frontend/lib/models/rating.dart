import 'package:flutter/material.dart';

class Rating {
  @required
  String _numberRatingResponses;
  @required
  String _rating;

  Rating(String numberRatingResponses, String rating) {
    this._numberRatingResponses = numberRatingResponses;
    this._rating = rating;
  }

  String get numberRatingResponses => this._numberRatingResponses;
  String get rating => this._rating;

  set numberRatingResponses(String _value) =>
      this._numberRatingResponses = _value;
  set rating(String _value) => this._rating = _value;

  @override
  String toString() {
    return "${this._numberRatingResponses} ${this._rating}";
  }
}
