import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;

class GiftCardPage extends StatefulWidget {
  final void Function(int) callbackSelectedIndex;

  const GiftCardPage({Key key, @required this.callbackSelectedIndex})
      : super(key: key);

  @override
  _GiftCardPageState createState() => _GiftCardPageState(callbackSelectedIndex);
}

class _GiftCardPageState extends State<GiftCardPage> {
  void Function(int) _callbackSelectedIndex;
  _GiftCardPageState(this._callbackSelectedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          _callbackSelectedIndex(0);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          return;
        },
        child: Container(
          child: Text("Something dummy to check if it works?"),
        ),
      ),
    );
  }
}
