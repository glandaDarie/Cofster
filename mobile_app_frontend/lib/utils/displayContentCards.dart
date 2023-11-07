/// Display content cards based on the provided [orderInformation] and optional [cardFlipParams].
///
/// If [cardFlipParams] contains exactly three elements:
///   - The first element is a callback function to toggle card flipping.
///   - The second element is a boolean value to determine if the card is flipped.
///   - The third element is an instance of [OrderInformation] to display on the card.
///
/// If [cardFlipParams] is empty or contains fewer than three elements, a default front card is displayed.
///
/// Example usage:
/// ```dart
/// displayContentCards(orderInfo, [toggleCallback, isFlipped, orderInfoToShow]);
/// ```

import 'package:coffee_orderer/models/orderInformation.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;
import 'package:coffee_orderer/utils/contentCardProperties.dart'
    show contentCardProperties;
import 'package:coffee_orderer/utils/coffeeNameToClassConvertor.dart'
    show coffeeNameToClassKey;
import 'package:coffee_orderer/components/orderScreen/frontOfCard.dart'
    show buildFrontCardContent;
import 'package:coffee_orderer/components/orderScreen/backOfCard.dart'
    show buildBackCardContent;
import 'package:coffee_orderer/enums/orderStatusTypes.dart'
    show CoffeeOrderState;

Widget displayContentCards(dynamic orderInformation,
    {List<dynamic> cardFlipParams = const []}) {
  assert(
      cardFlipParams.length == 0 || cardFlipParams.length == 3,
      "You did not call the function correctly. "
      "Please provide either no parameters to the params list or "
      " exactly two parameters.");
  orderInformation.coffeeName =
      coffeeNameToClassKey(orderInformation.coffeeName).toLowerCase();
  CoffeeType coffeeType = CoffeeType.values.firstWhere(
      (CoffeeType type) => type.index == classes[orderInformation.coffeeName],
      orElse: () => null);
  orderInformation.coffeeName = orderInformation.coffeeName[0].toUpperCase() +
      orderInformation.coffeeName.substring(1);
  Map<String, dynamic> cardProperties = contentCardProperties();
  return cardFlipParams.length == 3
      ? GestureDetector(
          onTap: () {
            cardFlipParams[0](cardFlipParams[2]);
          },
          child: Container(
            padding: cardProperties["padding"],
            margin: cardProperties["margin"],
            decoration: cardProperties["decoration"],
            child: cardFlipParams[1](cardFlipParams[2])
                ? buildBackCardContent(orderInformation, coffeeType)
                : buildFrontCardContent(
                    orderInformation,
                    coffeeType,
                    (dynamic orderInformation) => Text(
                      "Price: ${orderInformation.coffeePrice}\n"
                      "Quantity: ${orderInformation.quantity}\n"
                      "Size: ${orderInformation.coffeeCupSize}\n"
                      "Coffee Status: ${CoffeeOrderState.values[orderInformation.coffeeStatus].toString().split('.').last.split('_').join(' ')}\n"
                      "Order Placed: ${orderInformation.coffeeOrderTime}\n"
                      "Estimated Order: ${orderInformation.coffeeEstimationTime}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        )
      : Container(
          padding: cardProperties["padding"],
          margin: cardProperties["margin"],
          decoration: cardProperties["decoration"],
          child: buildFrontCardContent(
            orderInformation,
            coffeeType,
            (dynamic orderInformation) => Text(
              "Price: ${orderInformation.coffeePrice}\n"
              "Quantity: ${orderInformation.quantity}\n"
              "Size: ${orderInformation.coffeeCupSize}\n"
              "Temperature: ${orderInformation.coffeeTemperature}\n"
              "Cream: ${orderInformation.hasCream ? 'Yes' : 'No'}\n"
              "Sugar cubes: ${orderInformation.numberOfSugarCubes}\n"
              "Ice cubes: ${orderInformation.numberOfIceCubes}",
            ),
          ),
        );
}
