import 'package:flutter/material.dart';

Widget badgeWithLabel(int numberDrinks, IconData icon) {
  return Stack(
    children: [
      Icon(icon),
      if (numberDrinks > 0)
        Positioned(
          top: 0,
          right: -9,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 6,
              minHeight: 6,
            ),
            child: Text(
              numberDrinks.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}
