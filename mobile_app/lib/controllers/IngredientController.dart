import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/ingredient.dart' show Ingredient;
import 'package:coffee_orderer/utils/ingredientsProperties.dart'
    show ingredientNames, ingredientIcons, ingredientColors;
import 'package:coffee_orderer/enums/ingredientsTypes.dart'
    show IngredientsType;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/components/detailsScreen/ingredient.dart'
    show buildIngredient;

class IngredientController {
  List<Ingredient> allIngredients;
  IngredientController() {
    this.allIngredients = this._allIngredients();
  }

  List<Widget> filterIngredientsGivenSelectedDrink(
      List<String> drinkIngridientsNames) {
    List<Ingredient> drinkIngredients = this
        .allIngredients
        .where((Ingredient ingredient) =>
            drinkIngridientsNames.contains(ingredient.ingredientName))
        .toList();
    if (drinkIngredients.isEmpty) {
      Fluttertoast.showToast(
          msg:
              "Error: There is no ingredient present for that respective drink.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    return [
      ...drinkIngredients
          .map((Ingredient ingredient) => buildIngredient(ingredient)),
      if (drinkIngredients.isNotEmpty) SizedBox(width: 25.0),
    ].toList();
  }

  List<Ingredient> _allIngredients() {
    return [
      Ingredient(
          ingredientNames[IngredientsType.brewed_espresso],
          ingredientIcons[IngredientsType.brewed_espresso],
          ingredientColors[IngredientsType.brewed_espresso]),
      Ingredient(
          ingredientNames[IngredientsType.milk],
          ingredientIcons[IngredientsType.milk],
          ingredientColors[IngredientsType.milk]),
      Ingredient(
          ingredientNames[IngredientsType.sugar],
          ingredientIcons[IngredientsType.sugar],
          ingredientColors[IngredientsType.sugar]),
      Ingredient(
          ingredientNames[IngredientsType.water],
          ingredientIcons[IngredientsType.water],
          ingredientColors[IngredientsType.water]),
      Ingredient(
          ingredientNames[IngredientsType.toffee_nut_syrup],
          ingredientIcons[IngredientsType.toffee_nut_syrup],
          ingredientColors[IngredientsType.toffee_nut_syrup]),
      Ingredient(
          ingredientNames[IngredientsType.natural_flavors],
          ingredientIcons[IngredientsType.natural_flavors],
          ingredientColors[IngredientsType.natural_flavors]),
      Ingredient(
          ingredientNames[IngredientsType.vanilla_syrup],
          ingredientIcons[IngredientsType.vanilla_syrup],
          ingredientColors[IngredientsType.vanilla_syrup]),
      Ingredient(
          ingredientNames[IngredientsType.chocolate_syrup],
          ingredientIcons[IngredientsType.chocolate_syrup],
          ingredientColors[IngredientsType.chocolate_syrup]),
      Ingredient(
          ingredientNames[IngredientsType.ground_coffee],
          ingredientIcons[IngredientsType.ground_coffee],
          ingredientColors[IngredientsType.ground_coffee]),
      Ingredient(
          ingredientNames[IngredientsType.sambuca],
          ingredientIcons[IngredientsType.sambuca],
          ingredientColors[IngredientsType.sambuca]),
      Ingredient(
          ingredientNames[IngredientsType.irish_whiskey],
          ingredientIcons[IngredientsType.irish_whiskey],
          ingredientColors[IngredientsType.irish_whiskey])
    ];
  }
}
