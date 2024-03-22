import 'package:coffee_orderer/enums/coffeeTypes.dart';
import 'package:coffee_orderer/utils/boxProperties.dart'
    show sizes, additionalTopings;
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeePrices, coffeeNames;
import 'package:coffee_orderer/utils/toast.dart';
import 'package:coffee_orderer/utils/constants.dart' show FREE_DRINK_TAX;
import 'package:coffee_orderer/utils/drinkMadeByOrderType.dart'
    show OrderType, orderTypes;

Map<String, dynamic> updateUIWithChangesOnExtraIngredients(
  String coffeeName,
  String coffeeSize,
  int numberSugarCubes,
  OrderType orderType,
  int numberIceCubes,
  int hasCream, {
  int quantity = 1,
  String previousScreenName = "MainPage",
}) {
  final double coffeePrice = previousScreenName == "MainPage"
      ? _getCoffeePrice(coffeeName)
      : double.tryParse(FREE_DRINK_TAX) ?? null;
  if (coffeePrice == null) {
    ToastUtils.showToast("Coffee price not found");
    return null;
  }
  return {
    "quantity": quantity,
    "coffeeSize": coffeeSize,
    "numberSugarCubes": numberSugarCubes,
    "orderType": orderTypes[orderType],
    "numberIceCubes": numberIceCubes,
    "hasCream": hasCream == 1 ? true : false,
    "price": ((coffeePrice * quantity * sizes[coffeeSize]) +
            ((numberSugarCubes - 1) * additionalTopings["sugar"]) +
            ((numberIceCubes - 1) * additionalTopings["ice"]) +
            (hasCream == 1 ? additionalTopings["cream"] : 0))
        .toStringAsFixed(2),
  };
}

double _getCoffeePrice(String coffeeName) {
  final coffeeTypeEntry = coffeeNames.entries.firstWhere(
    (MapEntry<CoffeeType, String> entry) => entry.value == coffeeName,
    orElse: () => null,
  );
  if (coffeeTypeEntry != null) {
    final coffeeType = coffeeTypeEntry.key;
    final priceString = coffeePrices[coffeeType].replaceAll('\$', '');
    return double.tryParse(priceString ?? null);
  }
  return null;
}
