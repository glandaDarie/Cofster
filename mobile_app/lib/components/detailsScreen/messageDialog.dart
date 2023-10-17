import 'package:flutter/material.dart';

Widget MessageDialog({
  @required final String amount,
  @required final int numberOfCoffeeDrinks,
  @required final String coffeeName,
  @required final String message,
  final IconData iconData = Icons.check_circle,
  final Color iconColor = Colors.green,
  final double iconSize = 100.0,
}) {
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(height: 10.0),
        Text(
          message,
          textScaleFactor: 1.2,
          style:
              TextStyle(fontFamily: 'varela', color: Colors.black54).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
