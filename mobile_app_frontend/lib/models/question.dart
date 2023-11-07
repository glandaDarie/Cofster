import 'package:flutter/widgets.dart';

class Question {
  String _question;
  List<String> _options;
  Question({@required String question, @required List<String> options}) {
    this._question = question;
    this._options = options;
  }

  String get question => this._question;
  set question(String value) => this._question = value.trim();

  void addOption(String value) {
    this._options.add(value.trim());
  }

  void deleteOption(String value) {
    this._options.remove(value);
  }

  String getOption(int index) {
    return this._options[index];
  }

  List<String> getOptions() {
    return this._options;
  }

  void updateOption(String value, int index) {
    this._options[index] = value.trim();
  }

  @override
  String toString() {
    return "${this._question} ${this._options}";
  }
}
