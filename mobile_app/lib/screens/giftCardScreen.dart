import 'package:coffee_orderer/controllers/GiftController.dart'
    show GiftController;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/models/gift.dart' show Gift;

class GiftCardPage extends StatefulWidget {
  final void Function(int) callbackSelectedIndex;

  const GiftCardPage({Key key, @required this.callbackSelectedIndex})
      : super(key: key);

  @override
  _GiftCardPageState createState() => _GiftCardPageState(callbackSelectedIndex);
}

class _GiftCardPageState extends State<GiftCardPage> {
  void Function(int) _callbackSelectedIndex;
  GiftController _giftController;
  _GiftCardPageState(this._callbackSelectedIndex)
      : this._giftController = GiftController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () {
            _callbackSelectedIndex(0);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
            return;
          },
          child: FutureBuilder<List<Gift>>(future: () async {
            const bool testing = true;
            final String name = testing
                ? "ioan"
                : await LoggedInService.getSharedPreferenceValue("<nameUser>");
            final String username = testing
                ? "ioan@hotmai.com"
                : await LoggedInService.getSharedPreferenceValue("<username>");
            return await _giftController.getUserGifts(name, username);
          }(), builder:
              (BuildContext context, AsyncSnapshot<List<Gift>> snapshotGifts) {
            if (snapshotGifts.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    color: Colors.brown, backgroundColor: Colors.white),
              );
            } else if (snapshotGifts.hasError) {
              return Center(child: Text("Error: ${snapshotGifts.error}"));
            }
            List<Gift> gifts = snapshotGifts.data;
            return Text("Gifts: ${gifts}");
          })),
    );
  }
}
