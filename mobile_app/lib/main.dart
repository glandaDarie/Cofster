import 'package:flutter/material.dart';
// import 'package:coffee_orderer/screens/authScreen.dart';
// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
// import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:coffee_orderer/screens/loginScreen.dart';
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromARGB(255, 71, 66, 65),
        textColor: Color.fromARGB(255, 220, 217, 216),
        fontSize: 16);
    return;
  }
  NotificationService().initNotification("coffee_cappuccino");
  runApp(
    ChangeNotifierProvider(
      create: (context) => UpdateProvider(),
      child: MyApp(),
    ),
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthPage(),
      // home: QuestionnairePage(),
      // home: HomePage(),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
