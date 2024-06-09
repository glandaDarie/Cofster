import 'package:flutter/material.dart';
import 'dart:typed_data';

Container buildUserImage(AsyncSnapshot<Uint8List> snapshot, double screenWidth,
    double screenHeight) {
  Object image = snapshot.hasData
      ? MemoryImage(snapshot.data)
      : AssetImage("assets/images/no_profile_image.jpg");
  return Container(
    height: screenHeight * 0.09,
    width: screenHeight * 0.09,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      image: DecorationImage(
        image: image,
        fit: BoxFit.cover,
      ),
    ),
  );
}
