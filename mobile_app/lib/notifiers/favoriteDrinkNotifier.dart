import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;

class FavoriteDrinkNotifier {
  final CoffeeCard _card;
  CoffeeCardSingleton _coffeeCardSingleton;
  FavoriteDrinkNotifier(CoffeeCard card) : this._card = card {
    _coffeeCardSingleton = CoffeeCardSingleton(this._card.context);
  }

  void updateFavoriteStateForEachDrink(
      void Function(CoffeeCard, ValueNotifier<bool>) callbackSetFavorite) {
    final List<CoffeeCard> coffeeCardObjects =
        this._coffeeCardSingleton.getCoffeeCardObjects();
    for (CoffeeCard coffeeCardObject in coffeeCardObjects) {
      if (coffeeCardObject.coffeeName == this._card.coffeeName) {
        callbackSetFavorite(coffeeCardObject, this._card.isFavoriteNotifier);
      }
    }
  }

  void notifyChangeOnNumberOfFavoriteDrinks(
      ValueNotifier<int> numberFavoritesValueNotifier) {
    final int numberDrinksSetToFavorite =
        this._coffeeCardSingleton.getNumberOfSetFavoriteFromCoffeeCardObjects();
    numberFavoritesValueNotifier.value = numberDrinksSetToFavorite;
  }
}
