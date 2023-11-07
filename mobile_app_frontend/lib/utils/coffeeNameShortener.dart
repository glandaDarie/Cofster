import 'package:coffee_orderer/utils/constants.dart'
    show COFFEE_DRINKS_WITH_LONG_NAMES;

String shortenCoffeeNameIfNeeded(String coffeeName) {
  return COFFEE_DRINKS_WITH_LONG_NAMES.contains(coffeeName)
      ? coffeeName.split(" ")[1]
      : coffeeName;
}
