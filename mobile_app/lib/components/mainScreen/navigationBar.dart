import 'package:coffee_orderer/components/mainScreen/voiceDialog.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart';
import 'package:coffee_orderer/screens/profileInformationScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:coffee_orderer/components/mainScreen/badgeNumberOfFavorites.dart'
    show buildBadgeWidget;
import 'package:coffee_orderer/components/mainScreen/profileInformation.dart'
    show profileInformation;

ValueListenableBuilder bottomNavigationBar(
    ValueNotifier<int> selectedIndexValueNotifier,
    void Function(int) callbackSelectedIndex,
    bool speechStatus,
    void Function(bool) callbackSpeechStatus,
    bool startListening,
    dynamic Function(bool) callbackToggleListeningState,
    {int orderCount = 0,
    ValueNotifier<int> Function(BuildContext context) callbackFavoritesOn}) {
  ValueNotifier<int> orderCountValueNotifier = ValueNotifier<int>(orderCount);
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
        items: [
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
            onTap: () async {
              callbackSelectedIndex(1);
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (BuildContext context) =>
              //       profileInformation(context, AuthController()),
              // ));

              // change this from function to a new screen so I can use button back
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
                  valueListenable: orderCountValueNotifier,
                  builder:
                      (BuildContext context, int orderCount, Widget child) {
                    CoffeeCardSingleton coffeeCardSingleton =
                        CoffeeCardSingleton(context);
                    orderCount = coffeeCardSingleton
                        .getNumberOfSetFavoriteFromCoffeeCardObjects();
                    orderCountValueNotifier = ValueNotifier<int>(orderCount);
                    return buildBadgeWidget(orderCount);
                  })),
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
                      callbackToggleListeningState);
                },
                icon: Icon(
                  speechStatus ? Icons.mic : Icons.mic_off,
                  color: Color.fromARGB(255, 69, 45, 36),
                ),
              );
            },
          ),
        ],
        onTap: callbackSelectedIndex,
      );
    },
  );
}
