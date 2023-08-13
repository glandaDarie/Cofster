import 'package:flutter/material.dart';

Padding buildFooterImage(String imgPath) {
  return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Container(
          height: 100.0,
          width: 175.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  image: AssetImage(imgPath), fit: BoxFit.cover))));
}
