import 'package:flutter/material.dart';

Widget buildBadgeWidget(int orderCount) {
  return Stack(
    children: [
      Icon(Icons.history),
      // Icon(Icons.card_giftcard)
      if (orderCount > 0)
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
              orderCount.toString(),
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
