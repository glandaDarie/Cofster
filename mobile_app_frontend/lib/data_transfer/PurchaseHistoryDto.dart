import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'dart:convert';

class PurchaseHistoryDto {
  String email;
  String coffeeName;
  String coffeePrice;
  int quantity;
  String coffeeCupSize;
  String coffeeTemperature;
  bool hasCream;
  int numberOfSugarCubes;
  int numberOfIceCubes;

  PurchaseHistoryDto(
      {this.email,
      this.coffeeName,
      this.coffeePrice,
      this.quantity,
      this.coffeeCupSize,
      this.coffeeTemperature,
      this.hasCream,
      this.numberOfSugarCubes,
      this.numberOfIceCubes});

  factory PurchaseHistoryDto.fromOrderInformationModel(
      OrderInformation orderInformation,
      [String email = null]) {
    return PurchaseHistoryDto(
        email: email,
        coffeeName: orderInformation.coffeeName,
        coffeePrice: orderInformation.coffeePrice,
        quantity: orderInformation.quantity,
        coffeeCupSize: orderInformation.coffeeCupSize,
        coffeeTemperature: orderInformation.coffeeTemperature,
        hasCream: orderInformation.hasCream,
        numberOfSugarCubes: orderInformation.numberOfSugarCubes,
        numberOfIceCubes: orderInformation.numberOfIceCubes);
  }

  Map<String, dynamic> toMap() {
    return {
      "body": {
        "email": email,
        "coffeeName": coffeeName,
        "coffeePrice": coffeePrice,
        "quantity": quantity,
        "coffeeCupSize": coffeeCupSize,
        "coffeeTemperature": coffeeTemperature,
        "hasCream": hasCream,
        "numberOfSugarCubes": numberOfSugarCubes,
        "numberOfIceCubes": numberOfIceCubes
      }
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
