// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/authScreen.dart';
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification("coffee_cappuccino");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthPage(),
      // home: QuestionnairePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
