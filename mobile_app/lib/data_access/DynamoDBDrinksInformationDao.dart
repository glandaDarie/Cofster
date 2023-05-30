import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/information.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class DynamoDBDrinksInformationDao {
  String _url;

  DynamoDBDrinksInformationDao(String url) {
    this._url = url;
  }

  Future<Information> getInformationFromRespectiveDrink() async {
    Information information;
    this._url = this._url.trim();
    http.Response response = await http.get(Uri.parse(this._url));
    if (response.statusCode == 200) {
      information = this._parseJsonDrinkInformation(jsonDecode(response.body));
      if (information == null) {
        Fluttertoast.showToast(
            msg: "Error: problems when parsing the JSON",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color.fromARGB(255, 102, 33, 12),
            textColor: Color.fromARGB(255, 220, 217, 216),
            fontSize: 16);
        return null;
      }
      return information;
    }
    return null;
  }

  Information _parseJsonDrinkInformation(dynamic json) {
    List<dynamic> body = json["body"];
    if (body.isNotEmpty) {
      Map<String, dynamic> drinkInfo = body[0];
      dynamic ingredients = drinkInfo["ingredients"][0];
      String preparationTime = drinkInfo["Preparation time"];
      dynamic nutritionInfo = drinkInfo["Nutrition Information"][0];
      List<String> parsedIngredients = [];
      for (String key in ingredients.keys) {
        parsedIngredients.add(ingredients[key].toString());
      }
      List<String> parsedNutritionInfo = [];
      for (String key in nutritionInfo.keys) {
        parsedNutritionInfo.add(nutritionInfo[key].toString());
      }
      return Information(
          parsedIngredients, preparationTime, parsedNutritionInfo);
    }
    return null;
  }
}
