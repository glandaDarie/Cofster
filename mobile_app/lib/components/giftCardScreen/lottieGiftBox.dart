import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'package:coffee_orderer/utils/appAssets.dart' show GIFT_ANIMATION;
import 'package:coffee_orderer/components/detailsScreen/navigateToDetailsPage.dart'
    show navigateToDetailsPage;

Widget lottieGiftBox(
    {@required String gift,
    @required ValueNotifier<bool> animationPlayingNotifier}) {
  return ValueListenableBuilder(
    valueListenable: animationPlayingNotifier,
    builder: (BuildContext context, bool animationPlaying, Widget child) {
      return Container(
        margin: EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  animationPlayingNotifier.value = !animationPlaying;
                  navigateToDetailsPage(
                    currentScreenName: "GiftCardPage",
                    gift: gift,
                    context: context,
                  );
                },
                child: Lottie.asset(
                  GIFT_ANIMATION,
                  width: 350,
                  height: 250,
                  animate: !animationPlaying,
                  repeat: false,
                ),
              ),
              Container(
                child: Text(
                  "Gift: ${gift}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    fontFamily: "Roboto",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
