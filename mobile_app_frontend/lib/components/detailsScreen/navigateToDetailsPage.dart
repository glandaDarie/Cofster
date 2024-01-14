import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/patterns/coffeeCardSingleton.dart'
    show CoffeeCardSingleton;
import 'package:coffee_orderer/screens/detailsScreen.dart' show DetailsPage;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/controllers/CoffeeCardController.dart'
    show CoffeeCardController;
import 'package:coffee_orderer/utils/localUserInformation.dart'
    show storeUserInformationInCache;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

Future<void> navigateToDetailsPage({
  @required String currentScreenName,
  Future<void> Function({@required String sharedPreferenceKey})
      onSetDialogFormular,
  String gift = null,
  CoffeeCard card = null,
  BuildContext context,
}) async {
  CoffeeCardSingleton coffeeCardSingleton;
  if (gift != null) {
    coffeeCardSingleton = CoffeeCardSingleton(context);
    card = coffeeCardSingleton.getCoffeeCardWithMatchingName(name: gift);
  }
  String informationResponse =
      await _loadInformationToCacheForDetailsPage(card);
  if (informationResponse != null) {
    ToastUtils.showToast(informationResponse);
  }
  if (currentScreenName == "MainPage") {
    Navigator.of(card.context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          isGift: false,
          onSetDialogFormular: onSetDialogFormular,
        ),
      ),
    );
  } else if (currentScreenName == "GiftCardPage") {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => DetailsPage(
              isGift: true,
              onSetDialogFormular: onSetDialogFormular,
            ),
          ),
        );
      },
    );
  }
}

Future<String> _loadInformationToCacheForDetailsPage(
    CoffeeCard coffeeCard) async {
  bool cardIsFavorite =
      CoffeeCardController.getParticularCoffeeCardIsFavoriteState(coffeeCard);
  if (cardIsFavorite == null) {
    return "That respective coffee does not exist!";
  }
  await storeUserInformationInCache({
    "cardCoffeeName": coffeeCard.coffeeName.replaceAll(" ", "-"),
    "cardImgPath": coffeeCard.imgPath,
    "cardDescription": coffeeCard.description.replaceAll(" ", "-"),
    "cardIsFavorite": cardIsFavorite.toString()
  });
  return null;
}
