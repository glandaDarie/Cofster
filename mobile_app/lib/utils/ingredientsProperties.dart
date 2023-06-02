import 'package:coffee_orderer/enums/ingredientsTypes.dart'
    show IngredientsType;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

Map<IngredientsType, String> ingredientNames = {
  IngredientsType.brewed_espresso: "Brewed Espresso",
  IngredientsType.milk: "Milk",
  IngredientsType.sugar: "Sugar",
  IngredientsType.water: "Water",
  IngredientsType.toffee_nut_syrup: "Toffee Nut Syrup",
  IngredientsType.natural_flavors: "Natural Flavors",
  IngredientsType.vanilla_syrup: "Vanilla Syrup",
  IngredientsType.chocolate_syrup: "Chocolate Syrup",
  IngredientsType.ground_coffee: "Ground Coffee",
  IngredientsType.sambuca: "Sambuca",
  IngredientsType.irish_whiskey: "Irish Whiskey"
};

Map<IngredientsType, Icon> ingredientIcons = {
  IngredientsType.brewed_espresso:
      Icon(MaterialCommunityIcons.cow, size: 18.0, color: Colors.white),
  IngredientsType.milk:
      Icon(Feather.cloud_rain, size: 18.0, color: Colors.white),
  IngredientsType.sugar: Icon(Feather.box, size: 18.0, color: Colors.white),
  IngredientsType.water: Icon(Feather.droplet, size: 10.0, color: Colors.white),
  IngredientsType.toffee_nut_syrup: Icon(MaterialCommunityIcons.peanut_outline,
      size: 18.0, color: Colors.white),
  IngredientsType.natural_flavors:
      Icon(MaterialCommunityIcons.leaf_maple, size: 18.0, color: Colors.white),
  IngredientsType.vanilla_syrup:
      Icon(MaterialCommunityIcons.bottle_wine, size: 18.0, color: Colors.white),
  IngredientsType.chocolate_syrup:
      Icon(MaterialCommunityIcons.cupcake, size: 18.0, color: Colors.white),
  IngredientsType.ground_coffee:
      Icon(MaterialCommunityIcons.coffee, size: 18.0, color: Colors.white),
  IngredientsType.sambuca:
      Icon(MaterialCommunityIcons.glass_wine, size: 18.0, color: Colors.white),
  IngredientsType.irish_whiskey:
      Icon(MaterialCommunityIcons.glass_tulip, size: 18.0, color: Colors.white)
};

Map<IngredientsType, Color> ingredientColors = {
  IngredientsType.brewed_espresso: Color.fromARGB(255, 97, 89, 85),
  IngredientsType.milk: Color.fromARGB(255, 143, 179, 188),
  IngredientsType.sugar: Color.fromARGB(255, 243, 149, 149),
  IngredientsType.water: Color.fromARGB(255, 111, 197, 218),
  IngredientsType.toffee_nut_syrup: Color.fromARGB(255, 143, 194, 138),
  IngredientsType.natural_flavors: Color.fromARGB(255, 59, 128, 121),
  IngredientsType.vanilla_syrup: Color.fromARGB(255, 248, 184, 112),
  IngredientsType.chocolate_syrup: Color.fromARGB(255, 43, 42, 42),
  IngredientsType.ground_coffee: Color.fromARGB(255, 75, 43, 7),
  IngredientsType.sambuca: Color.fromARGB(255, 215, 69, 69),
  IngredientsType.irish_whiskey: Color.fromARGB(255, 27, 86, 101)
};
