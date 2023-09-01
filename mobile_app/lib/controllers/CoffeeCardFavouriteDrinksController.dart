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

class CoffeeCardFavouriteDrinksController {
  List<Padding> _cardsFavouriteDrinks;

  CoffeeCardFavouriteDrinksController() {
    this._cardsFavouriteDrinks = _initCoffeeCards();
  }

  List<Padding> _initCoffeeCards() {
    return [
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.cortado],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.cortado]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.cortado],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.americano],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.americano]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.americano],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.cappuccino],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.cappuccino]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.cappuccino],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.latteMachiatto],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.latteMachiatto]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.latteMachiatto],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.flatWhite],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.flatWhite]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.flatWhite],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coldEspresso],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.coldEspresso]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.coldEspresso],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.mocha],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.mocha]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.mocha],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coldBrew],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.coldBrew]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.coldBrew],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coretto],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.coretto]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.coretto],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.irishCoffee],
        shortenCoffeeNameIfNeeded(coffeeNames[CoffeeType.irishCoffee]),
        COFFEE_PLACE_NAME,
        coffeePrices[CoffeeType.irishCoffee],
      )),
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
