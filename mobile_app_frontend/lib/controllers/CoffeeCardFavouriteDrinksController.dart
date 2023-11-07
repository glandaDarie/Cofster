import 'package:coffee_orderer/models/card.dart';
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCardFavouriteDrinks.dart'
    show coffeeCardFavouriteDrink;
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;
import 'package:coffee_orderer/utils/coffeeNameShortener.dart'
    show shortenCoffeeNameIfNeeded;
import 'package:coffee_orderer/utils/constants.dart' show COFFEE_PLACE_NAME;
import 'package:coffee_orderer/utils/constants.dart' show COFFEE_TYPES;

class CoffeeCardFavouriteDrinksController {
  List<Padding> _cardsFavouriteDrinks;

  CoffeeCardFavouriteDrinksController() {
    this._cardsFavouriteDrinks = _initCoffeeCards();
  }

  List<Padding> _initCoffeeCards() {
    return [
      for (CoffeeType coffeeType in COFFEE_TYPES)
        coffeeCardFavouriteDrink(
          CoffeeCard(
            coffeeImagePaths[coffeeType],
            shortenCoffeeNameIfNeeded(coffeeNames[coffeeType]),
            COFFEE_PLACE_NAME,
            coffeePrices[coffeeType],
          ),
        )
    ];
  }

  List<Padding> filteredCoffeeCardsWithFavouriteDrinksFromClassifier(
      List<String> favouriteDrinks) {
    List<int> favouriteDrinkIndices = favouriteDrinks
        .map((String favouriteDrink) => classes[favouriteDrink.toLowerCase()])
        .toList();
    return this
        ._cardsFavouriteDrinks
        .asMap()
        .entries
        .where((MapEntry<int, Padding> entry) =>
            favouriteDrinkIndices.contains(entry.key))
        .map((MapEntry<int, Padding> entry) => entry.value)
        .toList();
  }
}
