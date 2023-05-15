// temporary debugging
import 'package:flutter/material.dart';
// import 'package:coffee_orderer/screens/authScreen.dart';
// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthPage(),
      // home: QuestionnairePage(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
