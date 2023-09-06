import 'package:coffee_orderer/utils/boxProperties.dart'
    show sizes, additionalTopings;
import 'package:coffee_orderer/utils/constants.dart' show DEFAULT_PRICE;

Map<String, dynamic> updateUIWithChangesOnExtraIngredients(String coffeeSize,
        int numberSugarCubes, int numberIceCubes, int hasCream,
        {int quantity = 1, String coffeeTemperature = "Cold"}) =>
    ({
      "quantity": quantity,
      "coffeeSize": coffeeSize,
      "numberSugarCubes": numberSugarCubes,
      "numberIceCubes": numberIceCubes,
      "hasCream": hasCream == 1 ? true : false,
      "price": ((DEFAULT_PRICE * quantity * sizes[coffeeSize]) +
              ((numberSugarCubes - 1) * additionalTopings["sugar"]) +
              ((numberIceCubes - 1) * additionalTopings["ice"]) +
              (hasCream == 1 ? additionalTopings["cream"] : 0))
          .toStringAsFixed(2),
      "coffeeTemperature": coffeeTemperature
    });
