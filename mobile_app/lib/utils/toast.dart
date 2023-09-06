import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast(
    String message, {
    toastLength = Toast.LENGTH_SHORT,
    Color backgroundColor,
    Color textColor,
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
