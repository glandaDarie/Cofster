import 'package:coffee_orderer/models/card.dart';
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCardFavouriteDrinks.dart'
    show coffeeCardFavouriteDrink;
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;

class CoffeeCardFavouriteDrinksController {
  List<Padding> cardsFavouriteDrinks;

  CoffeeCardFavouriteDrinksController() {
    this.cardsFavouriteDrinks = _initCoffeeCards();
  }

  List<Padding> _initCoffeeCards() {
    return [
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.cortado],
        coffeeNames[CoffeeType.cortado],
        "Cofster",
        coffeePrices[CoffeeType.cortado],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.americano],
        coffeeNames[CoffeeType.americano],
        "Cofster",
        coffeePrices[CoffeeType.americano],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.cappuccino],
        coffeeNames[CoffeeType.cappuccino],
        "Cofster",
        coffeePrices[CoffeeType.cappuccino],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.latteMachiatto],
        coffeeNames[CoffeeType.latteMachiatto],
        "Cofster",
        coffeePrices[CoffeeType.latteMachiatto],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.flatWhite],
        coffeeNames[CoffeeType.flatWhite],
        "Cofster",
        coffeePrices[CoffeeType.flatWhite],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coldEspresso],
        coffeeNames[CoffeeType.coldEspresso],
        "Cofster",
        coffeePrices[CoffeeType.coldEspresso],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.mocha],
        coffeeNames[CoffeeType.mocha],
        "Cofster",
        coffeePrices[CoffeeType.mocha],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coldBrew],
        coffeeNames[CoffeeType.coldBrew],
        "Cofster",
        coffeePrices[CoffeeType.coldBrew],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.coretto],
        coffeeNames[CoffeeType.coretto],
        "Cofster",
        coffeePrices[CoffeeType.coretto],
      )),
      coffeeCardFavouriteDrink(CoffeeCard(
        coffeeImagePaths[CoffeeType.irishCoffee],
        coffeeNames[CoffeeType.irishCoffee],
        "Cofster",
        coffeePrices[CoffeeType.irishCoffee],
      )),
    ];
  }

  List<Padding> filteredCoffeeCardsWithFavouriteDrinksFromClassifier(
      List<String> favouriteDrinks) {
    List<int> favouriteDrinkIndices = favouriteDrinks
        .map((favouriteDrink) => classes[favouriteDrink.toLowerCase()])
        .toList();
    return this
        .cardsFavouriteDrinks
        .asMap()
        .entries
        .where((entry) => favouriteDrinkIndices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }
}
