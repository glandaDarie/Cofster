import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/utils/appAssets.dart' show FooterImages;
import 'package:coffee_orderer/utils/drinkMadeByOrderType.dart' show OrderType;

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

const MAX_GIFTS = 1000;

const int DEFAULT_DRINK_QUANTITY = 1;
const String DEFAULT_DRINK_SIZE = "M";
final OrderType DEFAULT_ORDER_TYPE = OrderType.recipe;
const int DEFAULT_SUGAR_CUBES_QUANTITY = 0;
const int DEFAULT_ICE_CUBES_QUANTITY = 1;
const int DEFAULT_CREAM = 1;
const String FREE_DRINK_TAX = "0.50";
const String FILES_PATH = "assets/files";

const String LLM_FORMULAR_POPUP_MESSAGE =
    "Wanna have a special coffee recipe just for you?\nPlease help us by answering a formular.";
const String LLM_FORMULAR_POPUP_TITLE = "Rate drink";
const String LLM_FORMULAR_POPUP_PROCEED_TEXT = "Answer";
const String LLM_FORMULAR_POPUP_CANCEL_TEXT = "Cancel";

const String ORDERS_TABLE = "Orders";

const String HOST_EMAIL = "smtp-mail.outlook.com";
const int HOST_PORT = 587;

const int DIALOG_FORMULAR_TIMER_SECONDS = 10;
const int DIALOG_FORMULAR_PERIODIC_CHANGE_CHECK_TIME = 1;

const String COFFEE_RECOMMENDER_URL = "http://192.168.1.100:8001";
