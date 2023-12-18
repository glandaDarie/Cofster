import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coffee_orderer/utils/constants.dart'
    show PHONE_NUMBER, EMAIL_ADDRESS;
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: _HelpAndSupportPageState(),
    );
  }
}

class _HelpAndSupportPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
            );
          },
        ),
        title: Text(
          "Help and Support",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Text(
                "   Cofster Help and Support!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "\tIf you have any questions or need assistance, feel free to reach out to us:",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown[600],
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.brown[800],
                ),
                title: Text(
                  "Email: ${EMAIL_ADDRESS}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.brown[800],
                ),
                title: Text(
                  "Phone: ${PHONE_NUMBER}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[800],
                  ),
                ),
                onTap: () async {
                  final Uri UriLaunchSupportCall =
                      Uri(scheme: "tel", path: PHONE_NUMBER);
                  await launchUrl(UriLaunchSupportCall);
                },
              ),
              SizedBox(height: 25),
              Text(
                "\tOur dedicated team is here to assist you with any inquiries or feedback you may have. We value your feedback and strive to provide the best coffee experience!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown[600],
                ),
              ),
              SizedBox(height: 40),
              Text(
                "\tFollow us on social media for the latest updates:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GestureDetector(
                  //     onTap: () async {
                  //       final Uri uriLaunchFacebookProfile =
                  //           Uri(path: "https://www.facebook.com/darie.glanda");
                  //       launchUrl(uriLaunchFacebookProfile);
                  //     },
                  //     child: FaIcon(
                  //       FontAwesomeIcons.facebook,
                  //       color: Colors.brown,
                  //       size: 40,
                  //     )),
                  FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.brown,
                    size: 40,
                  ),
                  SizedBox(width: 40),
                  FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.brown,
                    size: 40,
                  ),
                  SizedBox(width: 40),
                  FaIcon(
                    FontAwesomeIcons.reddit,
                    color: Colors.brown,
                    size: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
