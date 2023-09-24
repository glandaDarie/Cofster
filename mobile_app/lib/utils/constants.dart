import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/utils/appAssets.dart' show FooterImages;

const String PHONE_NUMBER = "+40733209624";
const String EMAIL_ADDRESS = "cofster2023@outlook.com";
const String COFFEE_PLACE_NAME = "Cofster";

const List<CoffeeType> COFFEE_TYPES = [
  CoffeeType.cortado,
  CoffeeType.americano,
  CoffeeType.cappuccino,
  CoffeeType.latteMachiatto,
  CoffeeType.flatWhite,
  CoffeeType.coldEspresso,
  CoffeeType.mocha,
  CoffeeType.coldBrew,
  CoffeeType.coretto,
  CoffeeType.irishCoffee
];

const List<String> COFFEE_DRINKS_WITH_LONG_NAMES = [
  "Latte Machiatto",
  "Cold Espresso"
];

const List<String> PARTNER_COFFEE_SHOPS = [
  "Camera din Fata",
  "Cafe D'Arte",
  "La Fabrique"
];

final List<String> PARTNER_FOOTER_IMAGES = [
  FooterImages.COFFEE_IMAGE_1,
  FooterImages.COFFEE_IMAGE_2,
  FooterImages.COFFEE_IMAGE_3,
];
