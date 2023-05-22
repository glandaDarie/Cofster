import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart'
    show CoffeeCardSingleton;

class CoffeeCardController {
  BuildContext _context;
  Function(CoffeeCard, ValueNotifier<bool>) _onTapHeartLogo;
  List<Padding> _coffeeCards;
  List<CoffeeCard> _objectsCoffeeCards;

  CoffeeCardController(BuildContext context,
      void Function(CoffeeCard, ValueNotifier<bool>) onTapHeartLogo) {
    this._context = context;
    this._onTapHeartLogo = onTapHeartLogo;
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
    CoffeeCardSingleton coffeeCardSingleton =
        CoffeeCardSingleton(this._context);
    this._objectsCoffeeCards = coffeeCardSingleton.getCoffeeCardObjects();
    return [
      for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards)
        coffeeCard(objectCoffeeCard, this._onTapHeartLogo,
            this._onSendReferenceOfCoffeeCards),
    ].toList();
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
