import 'package:coffee_orderer/components/mainScreen/voiceDialog.dart';
import 'package:coffee_orderer/controllers/GiftController.dart';
import 'package:coffee_orderer/screens/giftCardScreen.dart';
import 'package:coffee_orderer/screens/profileInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:coffee_orderer/components/mainScreen/badgeWithLabel.dart'
    show badgeWithLabel;
import 'package:coffee_orderer/utils/message.dart' show Message;

ValueListenableBuilder bottomNavigationBar(
    ValueNotifier<int> selectedIndexValueNotifier,
    void Function(int) callbackSelectedIndex,
    bool speechStatus,
    void Function(bool) callbackSpeechStatus,
    bool startListening,
    dynamic Function(bool) callbackToggleListeningState,
    {ValueNotifier<int> numberFavoritesValueNotifier = null,
    ValueNotifier<int> Function(BuildContext context) callbackFavoritesOn,
    GiftController giftController}) {
  ValueNotifier<bool> speechStatusValueNotifier =
      ValueNotifier<bool>(speechStatus);
  return ValueListenableBuilder<int>(
    valueListenable: selectedIndexValueNotifier,
    builder: (BuildContext context, int selectedIndex, Widget child) {
      return CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: Color(0xFF473D3A),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          GestureDetector(
            onTap: () {
              callbackSelectedIndex(0);
            },
            child: Icon(
              Icons.home,
              color: Color.fromARGB(255, 69, 45, 36),
            ),
          ),
          GestureDetector(
            onTap: () {
              callbackSelectedIndex(1);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileInformationPage(
                      callbackSelectedIndex: callbackSelectedIndex)));
            },
            child: Icon(
              Icons.person,
              color: Color.fromARGB(255, 69, 45, 36),
            ),
          ),
          GestureDetector(
            onTap: () {
              callbackSelectedIndex(2);
            },
            child: ValueListenableBuilder<int>(
              valueListenable: numberFavoritesValueNotifier,
              builder: (BuildContext context, int numberOfSetOnFavorites,
                  Widget child) {
                return badgeWithLabel(numberOfSetOnFavorites, Icons.history);
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: speechStatusValueNotifier,
            builder: (BuildContext context, bool speechStatus, Widget child) {
              return IconButton(
                onPressed: () {
                  callbackSpeechStatus(speechStatus);
                  speechStatusValueNotifier.value = !speechStatus;
                  voiceDialog(
                    context,
                    speechStatusValueNotifier.value,
                    speechStatusValueNotifier,
                    callbackSpeechStatus,
                    startListening,
                    callbackToggleListeningState,
                  );
                },
                icon: Icon(
                  speechStatus ? Icons.mic : Icons.mic_off,
                  color: Color.fromARGB(255, 69, 45, 36),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              callbackSelectedIndex(4);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GiftCardPage(
                      callbackSelectedIndex: callbackSelectedIndex)));
            },
            child: FutureBuilder<dynamic>(
              future: giftController.getUserGifts(),
              builder: (final BuildContext context,
                  final AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return badgeWithLabel(0, Icons.wallet_giftcard);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                dynamic giftsResponse = snapshot.data;
                if (giftsResponse is String) {
                  return Message.error(
                    message: giftsResponse.toString(),
                  );
                }
                return badgeWithLabel(
                    giftsResponse.length, Icons.wallet_giftcard);
              },
            ),
          ),
        ],
        onTap: callbackSelectedIndex,
      );
    },
  );
}
