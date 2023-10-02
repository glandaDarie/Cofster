import 'package:flutter/material.dart';

class Message {
  static Padding error({
    padding = const EdgeInsets.all(70.0),
    @required String message,
    color = Colors.red,
    fontSize = 16.0,
  }) {
    return Padding(
      padding: EdgeInsets.all(70.0),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
