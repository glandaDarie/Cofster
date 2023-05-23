import 'package:coffee_orderer/components/mainScreen/voiceDialog.dart';
import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

Widget buildBadgeWidget(int orderCount) {
  return Stack(
    children: [
      Icon(Icons.history),
      if (orderCount > 0)
        Positioned(
          top: 0,
          right: -9,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 6,
              minHeight: 6,
            ),
            child: Text(
              orderCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}

ValueListenableBuilder bottomNavigationBar(
    int selectedIndex,
    void Function(int) callbackSelectedIndex,
    bool speechStatus,
    void Function(bool) callbackSpeechStatus,
    bool startListening,
    dynamic Function(bool) callbackToggleListeningState,
    [int orderCount = 0,
    ValueNotifier<int> Function(BuildContext context) callbackFavoritesOn]) {
  ValueNotifier<int> selectedIndexValueNotifier =
      ValueNotifier<int>(selectedIndex);
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
          Icon(Icons.home, color: Color.fromARGB(255, 69, 45, 36)),
          Icon(Icons.person, color: Color.fromARGB(255, 69, 45, 36)),
          GestureDetector(
              onTap: () {
                callbackSelectedIndex(selectedIndex);
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
