import 'package:coffee_orderer/models/ingredient.dart' show Ingredient;
import 'package:flutter/material.dart';

Padding buildIngredient(Ingredient ingredient) {
  return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Column(children: [
        Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: ingredient.ingredientColor),
            child: Center(child: ingredient.ingredientIcon)),
        SizedBox(height: 4.0),
        Container(
            width: 60.0,
            child: Center(
                child: Text(ingredient.ingredientName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'nunito',
                        fontSize: 12.0,
                        color: Color(0xFFC2C0C0)))))
      ]));
}
