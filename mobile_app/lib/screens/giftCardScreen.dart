import 'package:coffee_orderer/controllers/GiftController.dart'
    show GiftController;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/mainScreen.dart' show HomePage;
import 'package:coffee_orderer/utils/message.dart' show Message;
import 'package:coffee_orderer/components/giftCardScreen/lottieGiftBox.dart'
    show lottieGiftBox;
import 'package:quiver/iterables.dart' show zip;
import 'package:coffee_orderer/utils/constants.dart' show MAX_GIFTS;
import 'package:coffee_orderer/models/gift.dart' show Gift;

class GiftCardPage extends StatefulWidget {
  final void Function(int) callbackSelectedIndex;

  const GiftCardPage({Key key, @required this.callbackSelectedIndex})
      : super(key: key);

  @override
  _GiftCardPageState createState() => _GiftCardPageState(callbackSelectedIndex);
}

class _GiftCardPageState extends State<GiftCardPage>
    with TickerProviderStateMixin {
  void Function(int) _callbackSelectedIndex;
  GiftController _giftController;
  List<ValueNotifier<bool>> _animationPlayingNotifiers;

  _GiftCardPageState(this._callbackSelectedIndex)
      : this._giftController = GiftController(),
        this._animationPlayingNotifiers =
            List.generate(MAX_GIFTS, (int index) => ValueNotifier<bool>(true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "        Redeem gifts",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.brown.shade700,
      ),
      body: WillPopScope(
        onWillPop: () {
          _callbackSelectedIndex(0);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
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
              return Message.error(
                message: "Error: ${snapshotGifts.error}",
              );
            }
            final dynamic giftsResponse = snapshotGifts.data;
            if (giftsResponse is String) {
              return Message.error(
                message: giftsResponse.toString(),
              );
            }
            if (giftsResponse.length == 0) {
              return Message.info(
                message: "There are no gifts available at the moment!",
              );
            }
            if (giftsResponse.length >= MAX_GIFTS) {
              ToastUtils.showToast(
                  "Please empty your gift bucket, there are to many gifts!!");
            }
            final List<String> giftNames = (giftsResponse as List<Gift>)
                .map((Gift giftResponse) => giftResponse.gift.toString())
                .toList();
            return ListView(
              children: zip([giftNames, this._animationPlayingNotifiers])
                  .map(
                    (List<Object> pairs) => lottieGiftBox(
                      gift: pairs[0],
                      animationPlayingNotifier: pairs[1],
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
