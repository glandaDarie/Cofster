import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart';
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeeDescription, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;

class CoffeeCardController {
  BuildContext _context;
  Function(CoffeeCard, bool) _onTapHeartLogo;
  List<Padding> _coffeeCards;
  List<CoffeeCard> _objectsCoffeeCards;

  CoffeeCardController(
      BuildContext context, void Function(CoffeeCard, bool) onTapHeartLogo) {
    this._context = context;
    this._onTapHeartLogo = onTapHeartLogo;
  }

  Padding getParticularCoffeeCard(int index) {
    return this._coffeeCards[index];
  }

  void setCoffeeCard(int index, Padding _value) {
    this._coffeeCards[index] = _value;
  }

  List<CoffeeCard> getCoffeeCardObjects() {
    return [
      CoffeeCard(
          coffeeImagePaths[CoffeeType.cortado],
          coffeeNames[CoffeeType.cortado],
          "Cofster",
          coffeePrices[CoffeeType.cortado],
          coffeeDescription[CoffeeType.cortado],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.americano],
          coffeeNames[CoffeeType.americano],
          "Cofster",
          coffeePrices[CoffeeType.americano],
          coffeeDescription[CoffeeType.americano],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.cappuccino],
          coffeeNames[CoffeeType.cappuccino],
          "Cofster",
          coffeePrices[CoffeeType.cappuccino],
          coffeeDescription[CoffeeType.cappuccino],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.latteMachiatto],
          coffeeNames[CoffeeType.latteMachiatto],
          "Cofster",
          coffeePrices[CoffeeType.latteMachiatto],
          coffeeDescription[CoffeeType.latteMachiatto],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.flatWhite],
          coffeeNames[CoffeeType.flatWhite],
          "Cofster",
          coffeePrices[CoffeeType.flatWhite],
          coffeeDescription[CoffeeType.flatWhite],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coldEspresso],
          coffeeNames[CoffeeType.coldEspresso],
          "Cofster",
          coffeePrices[CoffeeType.coldEspresso],
          coffeeDescription[CoffeeType.coldEspresso],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.mocha],
          coffeeNames[CoffeeType.mocha],
          "Cofster",
          coffeePrices[CoffeeType.mocha],
          coffeeDescription[CoffeeType.mocha],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coldBrew],
          coffeeNames[CoffeeType.coldBrew],
          "Cofster",
          coffeePrices[CoffeeType.coldBrew],
          coffeeDescription[CoffeeType.coldBrew],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.coretto],
          coffeeNames[CoffeeType.coretto],
          "Cofster",
          coffeePrices[CoffeeType.coretto],
          coffeeDescription[CoffeeType.coretto],
          false,
          this._context),
      CoffeeCard(
          coffeeImagePaths[CoffeeType.irishCoffee],
          coffeeNames[CoffeeType.irishCoffee],
          "Cofster",
          coffeePrices[CoffeeType.irishCoffee],
          coffeeDescription[CoffeeType.irishCoffee],
          false,
          this._context)
    ];
  }

  List<CoffeeCard> _onSendReferenceOfCoffeeCards() {
    return this._objectsCoffeeCards;
  }

  List<Padding> getCoffeeCards() {
    this._objectsCoffeeCards = this.getCoffeeCardObjects();
    return [
      for (CoffeeCard objectCoffeeCard in this._objectsCoffeeCards)
        coffeeCard(objectCoffeeCard, this._onTapHeartLogo,
            this._onSendReferenceOfCoffeeCards),
    ].toList();
  }
}
