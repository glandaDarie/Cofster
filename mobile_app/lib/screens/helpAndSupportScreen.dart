import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coffee_orderer/utils/constants.dart' show PHONE_NUMBER;
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coffee Place Support",
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
        title: Text(
          "      Help and Support",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
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
                "Email: cofster2023@outlook.com",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown[800],
                ),
              ),
              onTap: () {
                // Open email client with pre-filled recipient
                // You might need to use a package like 'url_launcher'
              },
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
                final UriLaunchCall = Uri(scheme: "tel", path: PHONE_NUMBER);
                await launchUrl(UriLaunchCall);
                // Initiate a phone call
                // You might need to use a package like 'url_launcher'
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
                  FontAwesomeIcons.twitter,
                  color: Colors.brown,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
