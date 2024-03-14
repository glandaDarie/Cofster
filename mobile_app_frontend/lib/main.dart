import 'package:flutter/material.dart';
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
import 'package:coffee_orderer/providers/testScreenProvider.dart'
    show TestScreenProvider;
import 'package:coffee_orderer/screens/authScreen.dart' show AuthPage;
import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
// import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/screens/llmUpdaterFormularScreen.dart'
    show LLMUpdaterFormularPage;
// import 'package:coffee_orderer/screens/questionnaireScreen.dart';
// import 'package:coffee_orderer/screens/loginScreen.dart';
// import 'package:coffee_orderer/screens/testFormularCompletionDialogScreen.dart'
//     show TestScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await createUserInformationFile();
  } catch (error) {
    ToastUtils.showToast(error.toString());
    return;
  }

  // temporary fix - uncomment this whenever you change countries or the device,
  // because it will reset the shared preferences
  // await LoggedInService.setSharedPreferenceValue("<keepMeLoggedIn>");
  // String getKeepMeLoggedIn =
  //     await LoggedInService.getSharedPreferenceValue("<keepMeLoggedIn>");
  // LOGGER.i("getKeepMeLoggedIn: $getKeepMeLoggedIn");

  if (!(await LoggedInService.checkSharedPreferenceExistence(
      "<keepMeLoggedIn>"))) {
    await LoggedInService.setSharedPreferenceValue(
        "<keepMeLoggedIn>"); // whenever changing the IPv4, toggle this sharedPreferenceValue
  }
  NotificationService().initNotification("coffee_cappuccino");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderIDProvider.instance,
        ),
        ChangeNotifierProvider(
          create: (_) => TestScreenProvider(),
        ), // dummy code to check the dialog is working
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
            // home: TestScreen(),
            home: LLMUpdaterFormularPage(), // debugging
            // home: loggingStatusResponse ? HomePage() : AuthPage(),
            debugShowCheckedModeBanner: false,
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
