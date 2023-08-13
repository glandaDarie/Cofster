import 'package:flutter/material.dart';
import 'dart:typed_data';

Container buildUserImage(AsyncSnapshot<Uint8List> snapshot) {
  Object image = snapshot.hasData
      ? MemoryImage(snapshot.data)
      : AssetImage("assets/images/no_profile_image.jpg");
  return Container(
    height: 60.0,
    width: 60.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      image: DecorationImage(
        image: image,
        fit: BoxFit.cover,
      ),
    ),
  );
}
