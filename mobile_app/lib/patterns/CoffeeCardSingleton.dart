import 'package:coffee_orderer/models/card.dart';
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeeDescription, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:flutter/material.dart';

class CoffeeCardSingleton {
  static CoffeeCardSingleton _instance;
  static List<CoffeeCard> _coffeeCardObjectsInstance;

  CoffeeCardSingleton._();

  factory CoffeeCardSingleton(BuildContext context) {
    if (_instance == null) {
      _instance = CoffeeCardSingleton._();
      _coffeeCardObjectsInstance = _instance._getCoffeeCardObjects(context);
    }
    return _instance;
  }

  List<CoffeeCard> getCoffeeCardObjects() {
    return _coffeeCardObjectsInstance;
  }

  List<CoffeeCard> _getCoffeeCardObjects(context) {
    return [
      CoffeeCard(
          coffeeImagePaths[CoffeeType.cortado],
          coffeeNames[CoffeeType.cortado],
          "Cofster",
          coffeePrices[CoffeeType.cortado],
          coffeeDescription[CoffeeType.cortado],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.americano],
          coffeeNames[CoffeeType.americano],
          "Cofster",
          coffeePrices[CoffeeType.americano],
          coffeeDescription[CoffeeType.americano],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.cappuccino],
          coffeeNames[CoffeeType.cappuccino],
          "Cofster",
          coffeePrices[CoffeeType.cappuccino],
          coffeeDescription[CoffeeType.cappuccino],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.latteMachiatto],
          coffeeNames[CoffeeType.latteMachiatto],
          "Cofster",
          coffeePrices[CoffeeType.latteMachiatto],
          coffeeDescription[CoffeeType.latteMachiatto],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.flatWhite],
          coffeeNames[CoffeeType.flatWhite],
          "Cofster",
          coffeePrices[CoffeeType.flatWhite],
          coffeeDescription[CoffeeType.flatWhite],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coldEspresso],
          coffeeNames[CoffeeType.coldEspresso],
          "Cofster",
          coffeePrices[CoffeeType.coldEspresso],
          coffeeDescription[CoffeeType.coldEspresso],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.mocha],
          coffeeNames[CoffeeType.mocha],
          "Cofster",
          coffeePrices[CoffeeType.mocha],
          coffeeDescription[CoffeeType.mocha],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coldBrew],
          coffeeNames[CoffeeType.coldBrew],
          "Cofster",
          coffeePrices[CoffeeType.coldBrew],
          coffeeDescription[CoffeeType.coldBrew],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coretto],
          coffeeNames[CoffeeType.coretto],
          "Cofster",
          coffeePrices[CoffeeType.coretto],
          coffeeDescription[CoffeeType.coretto],
          false,
          context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.irishCoffee],
          coffeeNames[CoffeeType.irishCoffee],
          "Cofster",
          coffeePrices[CoffeeType.irishCoffee],
          coffeeDescription[CoffeeType.irishCoffee],
          false,
          context)
    ];
  }
}
