import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/authScreen.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;
import 'package:coffee_orderer/providers/orderIDProvider.dart'
    show OrderIDProvider;
import 'package:coffee_orderer/utils/localUserInformation.dart'
    show createUserInformationFile;
// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
// import 'package:coffee_orderer/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await createUserInformationFile();
    // String createFileResponse = await createUserInformationFile();
    // print("createFileResponse: ${createFileResponse}");
  } catch (error) {
    ToastUtils.showToast(error.toString());
    return;
  }
  if (!(await LoggedInService.checkSharedPreferenceExistence(
      "<keepMeLoggedIn>"))) {
    LoggedInService.setSharedPreferenceValue("<keepMeLoggedIn>");
  }
  NotificationService().initNotification("coffee_cappuccino");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UpdateProvider()),
        ChangeNotifierProvider(create: (_) => OrderIDProvider.instance),
      ],
      child: MaterialApp(
        home: CofsterPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class CofsterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LoggedInService.getSharedPreferenceValue("<keepMeLoggedIn>"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            dynamic loggingStatusResponse = snapshot.data;
            if (!(loggingStatusResponse is bool)) {
              return Text("${loggingStatusResponse}");
            }
            return MaterialApp(
              // home: AuthPage(),
              // home: QuestionnairePage(),
              // home: Home(),
              // home: HomePage(),
              home: loggingStatusResponse ? HomePage() : AuthPage(),
              debugShowCheckedModeBanner: false,
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
