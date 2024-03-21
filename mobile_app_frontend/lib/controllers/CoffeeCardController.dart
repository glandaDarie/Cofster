import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart'
    show coffeeCard;
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/patterns/coffeeCardSingleton.dart'
    show CoffeeCardSingleton;
import 'package:coffee_orderer/services/stringSimiliarityService.dart'
    show scoreProbability;

class CoffeeCardController {
  BuildContext _context;
  Function(CoffeeCard, ValueNotifier<bool>) _onTapHeartLogo;
  Future<void> Function({@required String sharedPreferenceKey})
      _onSetDialogFormular;
  List<Padding> _coffeeCards;
  List<CoffeeCard> _objectsCoffeeCards;
  CoffeeCardSingleton _coffeeCardSingleton;
  ValueNotifier<int> _numberFavoritesValueNotifier;

  CoffeeCardController(
      [BuildContext context,
      Future<void> Function({@required String sharedPreferenceKey})
          _onSetDialogFormular,
      void Function(CoffeeCard, ValueNotifier<bool>) onTapHeartLogo,
      ValueNotifier<int> _numberFavoritesValueNotifier]) {
    this._context = context;
    this._onTapHeartLogo = onTapHeartLogo;
    this._coffeeCardSingleton = CoffeeCardSingleton(this._context);
    this._objectsCoffeeCards = _coffeeCardSingleton.getCoffeeCardObjects();
    this._numberFavoritesValueNotifier = _numberFavoritesValueNotifier;
    this._onSetDialogFormular = _onSetDialogFormular;
  }

  Padding getParticularCoffeeCard(int index) {
    return this._coffeeCards[index];
  }

  void setCoffeeCard(int index, Padding _value) {
    this._coffeeCards[index] = _value;
  }

  List<CoffeeCard> onSendReferenceOfCoffeeCards() {
    return this._objectsCoffeeCards;
  }

  List<Padding> getCoffeeCards() {
    return [
      for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards)
        coffeeCard(
          objectCoffeeCard,
          this._onSetDialogFormular,
          this._onTapHeartLogo,
          this._numberFavoritesValueNotifier,
          this._context,
        ),
    ].toList();
  }

  CoffeeCard getParticularCoffeeCardGivenTheNameOfTheCoffeeFromSpeech(
      String coffeeNameSpeech,
      [double threshold = 0.6]) {
    for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards) {
      double probability =
          scoreProbability(coffeeNameSpeech, objectCoffeeCard.coffeeName);
      if (probability >= threshold) {
        return objectCoffeeCard;
      }
    }
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
