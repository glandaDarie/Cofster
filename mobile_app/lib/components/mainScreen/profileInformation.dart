import 'package:flutter/material.dart';

//dummy implementation
Future<Widget> profileInformation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('User Profile'),
        content: Text('This is the user profile dialog'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
