import 'package:flutter/widgets.dart';

class Question {
  String _question;
  String _options;
  Question({@required String question, @required String options}) {
    this._question = question;
    this._options = options;
  }

  String get question => this._question;
  String get options => this._options;

  set question(String _value) => this._question = _value.trim();
  set options(String _value) => this._options = _value.trim();

  @override
  String toString() {
    return "${this._question} ${this._options}";
  }
}
