import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart';
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeeDescription, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;

class CoffeeCardController {
  List<Padding> _coffeeCards;
  Function onTapHeartLogo;

  CoffeeCardController(BuildContext context, Function onTapHeartLogo) {
    this._coffeeCards = List.from(_initCoffeeCards(context));
    this.onTapHeartLogo = onTapHeartLogo;
  }

  List<Padding> getAllCofeeCards() {
    return this._coffeeCards;
  }

  Padding getParticularCoffeeCard(int index) {
    return this._coffeeCards[index];
  }

  void setCoffeeCard(int index, Padding _value) {
    this._coffeeCards[index] = _value;
  }

  List<Padding> _initCoffeeCards(BuildContext context) {
    return [
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.cortado],
              coffeeNames[CoffeeType.cortado],
              "Cofster",
              coffeePrices[CoffeeType.cortado],
              coffeeDescription[CoffeeType.cortado],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.americano],
              coffeeNames[CoffeeType.americano],
              "Cofster",
              coffeePrices[CoffeeType.americano],
              coffeeDescription[CoffeeType.americano],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.cappuccino],
              coffeeNames[CoffeeType.cappuccino],
              "Cofster",
              coffeePrices[CoffeeType.cappuccino],
              coffeeDescription[CoffeeType.cappuccino],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.latteMachiatto],
              coffeeNames[CoffeeType.latteMachiatto],
              "Cofster",
              coffeePrices[CoffeeType.latteMachiatto],
              coffeeDescription[CoffeeType.latteMachiatto],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.flatWhite],
              coffeeNames[CoffeeType.flatWhite],
              "Cofster",
              coffeePrices[CoffeeType.flatWhite],
              coffeeDescription[CoffeeType.flatWhite],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.coldEspresso],
              coffeeNames[CoffeeType.coldEspresso],
              "Cofster",
              coffeePrices[CoffeeType.coldEspresso],
              coffeeDescription[CoffeeType.coldEspresso],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.mocha],
              coffeeNames[CoffeeType.mocha],
              "Cofster",
              coffeePrices[CoffeeType.mocha],
              coffeeDescription[CoffeeType.mocha],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.coldBrew],
              coffeeNames[CoffeeType.coldBrew],
              "Cofster",
              coffeePrices[CoffeeType.coldBrew],
              coffeeDescription[CoffeeType.coldBrew],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.coretto],
              coffeeNames[CoffeeType.coretto],
              "Cofster",
              coffeePrices[CoffeeType.coretto],
              coffeeDescription[CoffeeType.coretto],
              false,
              context),
          onTapHeartLogo),
      coffeeCard(
          CoffeeCard(
              coffeeImagePaths[CoffeeType.irishCoffee],
              coffeeNames[CoffeeType.irishCoffee],
              "Cofster",
              coffeePrices[CoffeeType.irishCoffee],
              coffeeDescription[CoffeeType.irishCoffee],
              false,
              context),
          onTapHeartLogo),
    ];
  }
}
