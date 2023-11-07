import 'package:flutter/material.dart';

class Message {
  static Container error({
    @required String message,
    EdgeInsets padding = const EdgeInsets.all(70.0),
    Color color = Colors.red,
    double fontSize = 16.0,
  }) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(70.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  static Container info({
    @required String message,
    EdgeInsets padding = const EdgeInsets.all(100.0),
    double fontSize = 52.0,
    Color color = Colors.brown,
    FontStyle fontStyle = FontStyle.italic,
    double letterSpacing = 1.2,
    FontWeight fontWeight = FontWeight.bold,
    TextDecoration decoration = TextDecoration.none,
    double decorationThickness = 2.0,
  }) {
    return Container(
      child: Padding(
        padding: padding,
        child: Text(
          message,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationThickness: decorationThickness,
          ),
        ),
      ),
    );
  }
}
