import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/paths.dart' show Paths;
import 'package:coffee_orderer/screens/authScreen.dart' show AuthPage;

Widget profileInformation(BuildContext context, AuthController authController) {
  return FutureBuilder<Uint8List>(
    future: authController.loadUserPhoto(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: Container(
                  color: Colors.brown.shade700,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      _buildUserImageInProfileInformation(snapshot),
                      SizedBox(height: 15),
                      FutureBuilder(
                        future: authController.getNameFromCache(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Center(
                            child: Text(
                              snapshot.data ?? "Guest",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                  color: Colors.white),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Text(
                          "@cofster",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildProfileCard("Orders", Icons.privacy_tip_sharp,
                                () {
                              print("Privacy");
                            }),
                            _buildProfileCard("Purchase History", Icons.history,
                                () {
                              print("Purchase History");
                            }),
                            _buildProfileCard(
                                "Help & Support", Icons.help_outline, () {
                              print("Help & Support");
                            }),
                            _buildProfileCard(
                                "Settings", Icons.privacy_tip_sharp, () {
                              print("Settings");
                            }),
                            _buildProfileCard(
                                "Invite a Friend", Icons.add_reaction_sharp,
                                () {
                              print("Invite a Friend");
                            }),
                            _buildProfileCard("Logout", Icons.logout, () async {
                              String loggingStatusResponse =
                                  await LoggedInService.changeLoggingStatus(
                                      Paths.PATH_TO_FILE_KEEP_ME_LOGGED_IN);
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
                                builder: (context) => AuthPage(),
                              ));
                            }),
                          ],
                        ),
                      ),
                    ],
                  ))));
    },
  );
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
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
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
