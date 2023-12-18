import 'package:flutter/material.dart';

Widget bottomCoffeeDrinkButton({
  @required String buttonText,
  double height = 50.0,
  double borderRadius = 35.0,
  Color decorationColor = const Color(0xFF473D3A),
  String fontFamily = "nunito",
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.bold,
  Color colorTextStyle = Colors.white,
}) {
  return Flexible(
    child: Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: decorationColor,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: colorTextStyle,
            ),
          ),
        ),
      ),
    ),
  );
}
