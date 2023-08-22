import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Place Support',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HelpAndSupportPage(),
    );
  }
}

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Coffee Place Help and Support!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'If you have any questions or need assistance, feel free to reach out to us:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email: support@coffeeplace.com'),
              onTap: () {
                // Open email client with pre-filled recipient
                // You might need to use a package like 'url_launcher'
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone: +1234567890'),
              onTap: () {
                // Initiate a phone call
                // You might need to use a package like 'url_launcher'
              },
            ),
            SizedBox(height: 20),
            Text(
              'Our team is here to assist you with any inquiries or feedback you may have. We value your feedback and strive to provide the best coffee experience!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
