import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'dart:convert';

class PurchaseHistoryDto {
  String email;
  String coffeeName;
  String coffeePrice;
  int coffeeQuantity;
  String coffeeCupSize;
  String coffeeTemperature;
  bool coffeeHasCream;
  int coffeeNumberOfSugarCubes;
  int coffeeNumberOfIceCubes;

  PurchaseHistoryDto(
      {this.email,
      this.coffeeName,
      this.coffeePrice,
      this.coffeeQuantity,
      this.coffeeCupSize,
      this.coffeeTemperature,
      this.coffeeHasCream,
      this.coffeeNumberOfSugarCubes,
      this.coffeeNumberOfIceCubes});

  factory PurchaseHistoryDto.fromOrderInformationModel(
      OrderInformation orderInformation,
      [String email = null]) {
    return PurchaseHistoryDto(
        email: email,
        coffeeName: orderInformation.coffeeName,
        coffeePrice: orderInformation.coffeePrice,
        coffeeQuantity: orderInformation.quantity,
        coffeeCupSize: orderInformation.coffeeCupSize,
        coffeeTemperature: orderInformation.coffeeTemperature,
        coffeeHasCream: orderInformation.hasCream,
        coffeeNumberOfSugarCubes: orderInformation.numberOfSugarCubes,
        coffeeNumberOfIceCubes: orderInformation.numberOfIceCubes);
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "coffeeName": coffeeName,
      "coffeePrice": coffeePrice,
      "coffeeQuantity": coffeeQuantity,
      "coffeeCupSize": coffeeCupSize,
      "coffeeTemperature": coffeeTemperature,
      "hasCoffeeCream": coffeeHasCream,
      "coffeeNumberOfSugarCubes": coffeeNumberOfSugarCubes,
      "coffeeNumberOfIceCubes": coffeeNumberOfIceCubes
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
