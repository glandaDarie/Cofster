import 'package:coffee_orderer/screens/authScreen.dart';
import 'package:flutter/material.dart';
// import 'package:coffee_orderer/screens/authScreen.dart';
// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
// import 'package:coffee_orderer/screens/loginScreen.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/paths.dart' show Paths;

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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LoggedInService.getLoggingStatus(
            Paths.PATH_TO_FILE_KEEP_ME_LOGGED_IN),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          dynamic data = snapshot.data;
          if (data is String) {
            return Text(data);
          }
          return MaterialApp(
            // home: AuthPage(),
            // home: QuestionnairePage(),
            // home: Home(),
            // home: HomePage(),
            home: data ? HomePage() : AuthPage(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
