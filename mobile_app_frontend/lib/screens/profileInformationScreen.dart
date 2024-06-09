// import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'package:coffee_orderer/services/loggedInService.dart'
//     show LoggedInService;
// import 'package:coffee_orderer/controllers/AuthController.dart'
//     show AuthController;
// import 'package:coffee_orderer/components/profileInformationScreen/profileCards.dart'
//     show ProfileCards;

// class ProfileInformationPage extends StatefulWidget {
//   final void Function(int) callbackSelectedIndex;

//   const ProfileInformationPage({Key key, @required this.callbackSelectedIndex})
//       : super(key: key);

//   @override
//   _ProfileInformationPageState createState() =>
//       _ProfileInformationPageState(callbackSelectedIndex);
// }

// class _ProfileInformationPageState extends State<ProfileInformationPage> {
//   AuthController _authController;
//   void Function(int) _callbackSelectedIndex;

//   _ProfileInformationPageState(void Function(int) callbackSelectedIndex) {
//     _authController = AuthController();
//     _callbackSelectedIndex = callbackSelectedIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         _callbackSelectedIndex(
//             0); // change animation on NavBar back to the default HomePage
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (BuildContext context) => HomePage(),
//           ),
//         );
//         return;
//       },
//       child: FutureBuilder<Uint8List>(
//         future: _authController.loadUserPhoto(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: Scaffold(
//               body: Container(
//                 color: Colors.brown.shade700,
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 90,
//                     ),
//                     _UserImageInProfileInformation(snapshot),
//                     SizedBox(height: 15),
//                     FutureBuilder(
//                       future: Future.delayed(Duration(seconds: 3)).then(
//                         (_) => LoggedInService.getSharedPreferenceValue(
//                             "<nameUser>"),
//                       ),
//                       builder: (BuildContext context, AsyncSnapshot snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return CircularProgressIndicator(
//                               color: Colors.brown,
//                               backgroundColor: Colors.white);
//                         } else if (snapshot.hasData) {
//                           return Center(
//                             child: Text(
//                               snapshot.data,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w900,
//                                   fontSize: 26,
//                                   color: Colors.white),
//                             ),
//                           );
//                         } else {
//                           return Center(
//                             child: Text(
//                               "Guest",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w900,
//                                   fontSize: 26,
//                                   color: Colors.white),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                     Center(
//                       child: Text(
//                         "@cofster",
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         children: [
//                           ...ProfileCards(context),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// Center _UserImageInProfileInformation(AsyncSnapshot snapshot) {
//   Object image = snapshot.hasData
//       ? MemoryImage(snapshot.data)
//       : AssetImage("assets/images/no_profile_image.jpg");
//   return Center(
//     child: CircleAvatar(
//       maxRadius: 65,
//       backgroundImage: image,
//     ),
//   );
// }

import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/controllers/AuthController.dart'
    show AuthController;
import 'package:coffee_orderer/components/profileInformationScreen/profileCards.dart'
    show ProfileCards;

class ProfileInformationPage extends StatefulWidget {
  final void Function(int) callbackSelectedIndex;

  const ProfileInformationPage({Key key, @required this.callbackSelectedIndex})
      : super(key: key);

  @override
  _ProfileInformationPageState createState() =>
      _ProfileInformationPageState(callbackSelectedIndex);
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  AuthController _authController;
  void Function(int) _callbackSelectedIndex;

  _ProfileInformationPageState(void Function(int) callbackSelectedIndex) {
    _authController = AuthController();
    _callbackSelectedIndex = callbackSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return WillPopScope(
      onWillPop: () {
        _callbackSelectedIndex(
            0); // change animation on NavBar back to the default HomePage
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
        );
        return Future.value(false);
      },
      child: FutureBuilder<Uint8List>(
        future: _authController.loadUserPhoto(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.brown.shade700,
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        _UserImageInProfileInformation(snapshot, screenWidth),
                        SizedBox(height: screenHeight * 0.02),
                        FutureBuilder(
                          future: Future.delayed(Duration(seconds: 3)).then(
                            (_) => LoggedInService.getSharedPreferenceValue(
                                "<nameUser>"),
                          ),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                  color: Colors.brown,
                                  backgroundColor: Colors.white);
                            } else if (snapshot.hasData) {
                              return Center(
                                child: Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: screenWidth * 0.065,
                                      color: Colors.white),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Guest",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: screenWidth * 0.065,
                                      color: Colors.white),
                                ),
                              );
                            }
                          },
                        ),
                        Center(
                          child: Text(
                            "@cofster",
                            style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.white),
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ...ProfileCards(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Center _UserImageInProfileInformation(
    AsyncSnapshot snapshot, double screenWidth) {
  Object image = snapshot.hasData
      ? MemoryImage(snapshot.data)
      : AssetImage("assets/images/no_profile_image.jpg");
  return Center(
    child: CircleAvatar(
      maxRadius: screenWidth * 0.2,
      backgroundImage: image,
    ),
  );
}
