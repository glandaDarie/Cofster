import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(
    String message, {
    toastLength = Toast.LENGTH_SHORT,
    Color backgroundColor = const Color.fromARGB(255, 102, 33, 12),
    Color textColor = const Color.fromARGB(255, 220, 217, 216),
    double fontSize = 16,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
