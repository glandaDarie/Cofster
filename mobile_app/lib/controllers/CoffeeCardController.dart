import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart'
    show CoffeeCardSingleton;
import 'package:coffee_orderer/utils/stringSimiliarity.dart'
    show scoreProbability;
import 'package:fluttertoast/fluttertoast.dart';

class CoffeeCardController {
  BuildContext _context;
  Function(CoffeeCard, ValueNotifier<bool>) _onTapHeartLogo;
  List<Padding> _coffeeCards;
  List<CoffeeCard> _objectsCoffeeCards;
  CoffeeCardSingleton _coffeeCardSingleton;

  CoffeeCardController(
      [BuildContext context,
      void Function(CoffeeCard, ValueNotifier<bool>) onTapHeartLogo]) {
    this._context = context;
    this._onTapHeartLogo = onTapHeartLogo;
    this._coffeeCardSingleton = CoffeeCardSingleton(this._context);
    this._objectsCoffeeCards = _coffeeCardSingleton.getCoffeeCardObjects();
  }

  Padding getParticularCoffeeCard(int index) {
    return this._coffeeCards[index];
  }

  void setCoffeeCard(int index, Padding _value) {
    this._coffeeCards[index] = _value;
  }

  List<CoffeeCard> _onSendReferenceOfCoffeeCards() {
    return this._objectsCoffeeCards;
  }

  List<Padding> getCoffeeCards() {
    return [
      for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards)
        coffeeCard(objectCoffeeCard, this._onTapHeartLogo,
            this._onSendReferenceOfCoffeeCards),
    ].toList();
  }

  CoffeeCard getParticularCoffeeCardGivenTheNameOfTheCoffeeFromSpeech(
      String coffeeNameSpeech,
      [double threshold = 0.6]) {
    for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards) {
      print("Current drink = ${objectCoffeeCard.coffeeName}");
      double probability =
          scoreProbability(coffeeNameSpeech, objectCoffeeCard.coffeeName);
      print("Score probability = ${probability}");
      if (probability >= threshold) {
        return objectCoffeeCard;
      }
    }
    Fluttertoast.showToast(
        msg:
            "There is no coffee card in the list of coffee cards that has that name",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromARGB(255, 102, 33, 12),
        textColor: Color.fromARGB(255, 220, 217, 216),
        fontSize: 16);
    return null;
  }

  static bool getParticularCoffeeCardIsFavoriteState(CoffeeCard card) {
    CoffeeCardSingleton coffeeCardInstance = CoffeeCardSingleton(card.context);
    List<CoffeeCard> coffeeCardObjects =
        coffeeCardInstance.getCoffeeCardObjects();
    CoffeeCard matchingCard = coffeeCardObjects.firstWhere(
      (coffeeCardObject) => coffeeCardObject.coffeeName == card.coffeeName,
      orElse: () => null,
    );
    return matchingCard.isFavoriteNotifier.value;
  }
}
