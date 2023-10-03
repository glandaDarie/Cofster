import 'package:coffee_orderer/controllers/GiftController.dart'
    show GiftController;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/utils/message.dart' show Message;

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
          child: FutureBuilder<dynamic>(
              future: this._giftController.getUserGifts(),
              builder: (final BuildContext contextGifts,
                  final AsyncSnapshot<dynamic> snapshotGifts) {
                if (snapshotGifts.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.brown, backgroundColor: Colors.white),
                  );
                } else if (snapshotGifts.hasError) {
                  return Center(
                    child: Text("Error: ${snapshotGifts.error}"),
                  );
                }

                dynamic giftsResponse = snapshotGifts.data;
                if (giftsResponse is String) {
                  return Message.error(
                    message: giftsResponse.toString(),
                  );
                }

                // List<LottieObjects> will be here instead of this dummy implementation
                return Message.error(
                  message: giftsResponse.toString(),
                );

                // return Padding(
                //     padding: EdgeInsets.all(70.0),
                //     child: Text(giftsResponse.toString(),
                //         style: TextStyle(
                //           color: Colors.red,
                //           fontSize: 16.0,
                //         )));

                // dummy debugging implementation for now
                // should create here a component that accepts the gifts as parameter and create the lottie element
                // should return a List<LottieObject> where LottieObject will be mapped to the each gift

                // return Padding(
                //   padding: EdgeInsets.all(70.0),
                //   child: Text("Gifts: ${gifts}"),
                // );

                // check here if the JSON is parsed correctly and the update will be performed in the DynamoDB database
                // return FutureBuilder<String>(future: () async {
                //   // dummy testing the implementation here
                //   String name = "daniel";
                //   String username = "mihaimicea@yahoo.com";
                //   String gift = "Americano";
                //   return await this
                //       ._giftController
                //       .deleteUserGift(name, username, gift);
                // }(), builder: (final BuildContext context,
                //     final AsyncSnapshot<String> spashotAddedGift) {
                //   if (spashotAddedGift.connectionState == ConnectionState.waiting) {
                //     return const Center(
                //       child: CircularProgressIndicator(
                //           color: Colors.brown, backgroundColor: Colors.white),
                //     );
                //   } else if (spashotAddedGift.hasError) {
                //     return Center(
                //       child: Text("Error: ${spashotAddedGift.error}"),
                //     );
                //   }

                //   String giftAddedResponse = spashotAddedGift.data;
                //   if (giftAddedResponse != null) {
                //     return Padding(
                //         padding: EdgeInsets.all(70.0),
                //         child: Text(giftAddedResponse,
                //             style: TextStyle(
                //               color: Colors.red,
                //               fontSize: 16.0,
                //             )));
                //   }
                //   return Padding(
                //     padding: EdgeInsets.all(70.0),
                //     child: Text(
                //         "Gifts: ${giftsResponse}, \n Message: ${giftAddedResponse}"),
                //   );
                // });
              })),
    );
  }
}
