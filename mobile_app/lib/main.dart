// temporary debugging
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/questionnaireScreen.dart';
// import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:coffee_orderer/screens/authScreen.dart';
// import 'package:coffee_orderer/screens/mainScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification("coffee_cappuccino");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuestionnairePage(),
      // home: AuthPage(),
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
