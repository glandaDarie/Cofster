import 'package:coffee_orderer/components/detailsScreen/ratingBar.dart'
    show RatingBarDrink;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart';
import 'package:coffee_orderer/data_transfer/PurchaseHistoryDto.dart';
import 'package:coffee_orderer/models/information.dart';
import 'package:coffee_orderer/services/loggedInService.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/controllers/OrderInformationController.dart'
    show OrderInformationController;
import 'package:coffee_orderer/enums/orderStatusTypes.dart'
    show CoffeeOrderState;
import 'package:coffee_orderer/services/timeOrdererService.dart'
    show timeOfOrder;
import 'package:coffee_orderer/controllers/DrinksInformationController.dart'
    show DrinksInformationController;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class OrderService {
  BuildContext _context;
  PaymentService _paymentService;
  PurchaseHistoryController _purchaseHistoryController;
  Map<String, dynamic> _extraIngredients;
  ValueNotifier<bool> _placedOrderNotifier;
  OrderService(
    this._context,
    this._paymentService,
    this._purchaseHistoryController,
    this._extraIngredients,
    this._placedOrderNotifier,
  );

  Future<void> placeOrder() async {
    String cacheStr = await loadUserInformationFromCache();
    Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
    String paymentResponse = await this._paymentService.makePayment(
        this._context,
        (double.parse(this._extraIngredients["price"]) * 100)
            .toInt()
            .toStringAsFixed(0),
        cache["cardCoffeeName"],
        "USD",
        numberOfCoffeeDrinks: this._extraIngredients["quantity"]);
    if (paymentResponse != "success") {
      ToastUtils.showToast(paymentResponse);
      return;
    }

    String coffeeName = this._getProcessedCoffeeName(cache);
    dynamic preparationTime =
        await this._fromProcessedNameGetCoffeePreparationTime(coffeeName);
    if (preparationTime.runtimeType is String) {
      ToastUtils.showToast(preparationTime);
      return;
    }

    String postOrderResponse =
        await this._placeOrderToMessageBroker(coffeeName, preparationTime);
    if (postOrderResponse != null) {
      ToastUtils.showToast(postOrderResponse);
      return;
    }

    String postUsersPurchaseResponse =
        await this._placeOrderInUsersOrderHistory(coffeeName);
    if (postUsersPurchaseResponse != null) {
      ToastUtils.showToast(postUsersPurchaseResponse);
      return;
    }

    RatingBarDrink.startRatingDisplayCountdown(
      this._context,
      this._placedOrderNotifier,
    );
  }

  String _getProcessedCoffeeName(Map<String, String> cache) {
    return cache["cardCoffeeName"]
        .split("-")
        .map((String word) => "${word[0].toUpperCase()}${word.substring(1)}")
        .toList()
        .join();
  }

  Future<dynamic> _fromProcessedNameGetCoffeePreparationTime(
      String coffeeName) async {
    DrinksInformationController drinkInformationController =
        DrinksInformationController();
    Information information = await drinkInformationController
        .getInformationFromRespectiveDrink(coffeeName);
    int preparationTime;
    try {
      preparationTime = int.parse(information.preparationTime.split(" ")[0]);
    } catch (error) {
      return "Error, could not get the preparation time: ${error}";
    }
    return preparationTime;
  }

  Future<String> _placeOrderToMessageBroker(
    String coffeeName,
    int preparationTime,
  ) async {
    String postOrderResponse =
        await OrderInformationController.postOrderToOrdersInformation(
            "Orders", {
      "coffeeName": coffeeName,
      "coffeePrice": "${this._extraIngredients["price"]}\$",
      "quantity": this._extraIngredients["quantity"],
      "communication": "broadcast",
      "coffeeStatus": CoffeeOrderState.ORDER_PLACED.index,
      "coffeeOrderTime": timeOfOrder(),
      "coffeeFinishTimeEstimation": timeOfOrder(
          secondsDelay: preparationTime * this._extraIngredients["quantity"]),
      "coffeeCupSize": this._extraIngredients["coffeeSize"],
      "coffeeTemperature": this._extraIngredients["coffeeTemperature"],
      "numberOfSugarCubes": this._extraIngredients["numberSugarCubes"],
      "numberOfIceCubes": this._extraIngredients["numberIceCubes"],
      "hasCream": this._extraIngredients["hasCream"]
    });
    return postOrderResponse;
  }

  Future<String> _placeOrderInUsersOrderHistory(String coffeeName) async {
    String postUsersPurchaseResponse = await this
        ._purchaseHistoryController
        .postUsersPurchase(
          PurchaseHistoryDto(
            email: await LoggedInService.getSharedPreferenceValue("<username>"),
            coffeeName: coffeeName.replaceAllMapped(
              RegExp(r"([a-z])([A-Z])"),
              (match) => "${match.group(1)} ${match.group(2)}",
            ),
            coffeePrice: "${this._extraIngredients["price"]}\$",
            quantity: this._extraIngredients["quantity"],
            coffeeCupSize: this._extraIngredients["coffeeSize"],
            coffeeTemperature: this._extraIngredients["coffeeTemperature"],
            hasCream: this._extraIngredients["hasCream"],
            numberOfSugarCubes: this._extraIngredients["numberSugarCubes"],
            numberOfIceCubes: this._extraIngredients["numberIceCubes"],
          ),
        );
    return postUsersPurchaseResponse;
  }
}
