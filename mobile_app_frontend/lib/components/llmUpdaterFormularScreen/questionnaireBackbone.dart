import 'package:flutter/material.dart';

Scaffold QuestionnaireBackbone({
  @required String title,
  @required Function fn,
  Map<String, dynamic> params = const {},
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.brown,
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.brown.shade200, Colors.brown.shade700],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: fn(params: params),
      ),
    ),
  );
}
