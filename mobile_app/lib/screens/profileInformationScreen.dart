import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/paths.dart' show Paths;
import 'package:coffee_orderer/screens/authScreen.dart' show AuthPage;
import 'package:coffee_orderer/services/inviteAFriendService.dart'
    show InvitieAFriendService;
import 'package:coffee_orderer/utils/catchPhrases.dart' show CatchPhrases;
import 'package:coffee_orderer/screens/orderScreen.dart' show OrderPage;
import 'package:coffee_orderer/controllers/AuthController.dart'
    show AuthController;
import 'package:coffee_orderer/screens/helpAndSupportScreen.dart'
    show HelpAndSupportPage;
import 'package:coffee_orderer/screens/purchaseHistoryScreen.dart'
    show PurchaseHistoryPage;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;

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
    return WillPopScope(
      onWillPop: () async {
        _callbackSelectedIndex(
            0); // change animation on NavBar back to the default HomePage
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        return;
      },
      child: FutureBuilder<Uint8List>(
        future: _authController.loadUserPhoto(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Container(
                      color: Colors.brown.shade700,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 90,
                          ),
                          _buildUserImageInProfileInformation(snapshot),
                          SizedBox(height: 15),
                          FutureBuilder(
                            future: Future.delayed(Duration(seconds: 3)).then(
                                (_) => LoggedInService.getSharedPreferenceValue(
                                    "<nameUser>")),
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
                                        fontSize: 26,
                                        color: Colors.white),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "Guest",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 26,
                                        color: Colors.white),
                                  ),
                                );
                              }
                            },
                          ),
                          Center(
                            child: Text(
                              "@cofster",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                _buildProfileCard("Orders In Progress",
                                    Icons.history_edu_sharp, () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OrderPage()));
                                }),
                                _buildProfileCard(
                                    "Purchase History", Icons.history,
                                    () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PurchaseHistoryPage(
                                              purchaseHistoryController:
                                                  PurchaseHistoryController())));
                                }),
                                _buildProfileCard(
                                    "Help & Support", Icons.privacy_tip_sharp,
                                    () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HelpAndSupportPage(),
                                  ));
                                }),
                                _buildProfileCard(
                                    "Invite a Friend", Icons.add_reaction_sharp,
                                    () async {
                                  await InvitieAFriendService
                                      .displayCofsterLocationMap(
                                          Paths.PATH_TO_COFSTER_LOCATION,
                                          catchPhrase: CatchPhrases
                                              .CATCH_PHRASE_COFSTER);
                                }),
                                _buildProfileCard("Logout", Icons.logout,
                                    () async {
                                  String loggingStatusResponse =
                                      await LoggedInService
                                          .changeSharedPreferenceLoggingStatus();
                                  if (loggingStatusResponse != null) {
                                    Fluttertoast.showToast(
                                        msg: loggingStatusResponse,
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor:
                                            Color.fromARGB(255, 102, 33, 12),
                                        textColor:
                                            Color.fromARGB(255, 220, 217, 216),
                                        fontSize: 16);
                                    return null;
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthPage(),
                                  ));
                                }),
                              ],
                            ),
                          ),
                        ],
                      ))));
        },
      ),
    );
  }
}

Center _buildUserImageInProfileInformation(AsyncSnapshot snapshot) {
  Object image = snapshot.hasData
      ? MemoryImage(snapshot.data)
      : AssetImage("assets/images/no_profile_image.jpg");
  return Center(
    child: CircleAvatar(
      maxRadius: 65,
      backgroundImage: image,
    ),
  );
}

Card _buildProfileCard(String name, IconData icon, VoidCallback onTapCallback) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: ListTile(
      onTap: onTapCallback,
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        name,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black54),
    ),
  );
}
