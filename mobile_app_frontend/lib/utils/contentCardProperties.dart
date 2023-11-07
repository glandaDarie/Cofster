import 'package:flutter/material.dart';

Map<String, dynamic> contentCardProperties() {
  return {
    "padding": const EdgeInsets.all(16.0),
    "margin": const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    "decoration": BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.brown.shade400,
    )
  };
}
