import 'package:coffee_orderer/models/orderInformation.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/data_transfer/PurchaseHistoryDto.dart'
    show PurchaseHistoryDto;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class DynamoDBPurchaseHistoryDao {
  final String _url;

  DynamoDBPurchaseHistoryDao(String url) : this._url = url.trim();

  Future<List<PurchaseHistoryDto>> getUsersPurchaseHistory() async {
    try {
      final http.Response response = await http.get(Uri.parse(this._url));
      if (response.statusCode == 200) {
        final List<PurchaseHistoryDto> purchaseHistory =
            this._parseJsonUsersPurchaseHistory(jsonDecode(response.body));
        if (purchaseHistory == null) {
          Fluttertoast.showToast(
              msg: "Error: problems when parsing the JSON",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Color.fromARGB(255, 102, 33, 12),
              textColor: Color.fromARGB(255, 220, 217, 216),
              fontSize: 16);
          return null;
        }
        return purchaseHistory;
      }
    } catch (error) {
      throw "Error when trying to fetch the data: ${error}";
    }
    return null;
  }

  List<PurchaseHistoryDto> _parseJsonUsersPurchaseHistory(
      dynamic jsonPurchaseHistory) {
    List<PurchaseHistoryDto> purchasesHistoryDto = [];
    final dynamic orderInformations =
        jsonPurchaseHistory["body"]["orderInformation"];
    final String email = jsonPurchaseHistory["body"]["email"];
    for (int index = 0; index < orderInformations.length; ++index) {
      final Map<String, dynamic> orderInformation = orderInformations[index];
      final Map<String, dynamic> order =
          Map<String, dynamic>.from(orderInformation["purchase_${index + 1}"]);
      final dynamic purchaseHistoryDto =
          PurchaseHistoryDto.fromOrderInformationModel(
              OrderInformation(
                  coffeeName: order["coffeeName"],
                  coffeePrice: order["coffeePrice"],
                  quantity: order["coffeeQuantity"],
                  coffeeCupSize: order["coffeeCupSize"],
                  numberOfIceCubes: order["coffeeNumberOfIceCubes"],
                  numberOfSugarCubes: order["coffeeNumberOfSugarCubes"],
                  coffeeTemperature: order["coffeeTemperature"],
                  hasCream: order["hasCoffeeCream"] == 0 ? false : true),
              email);
      purchasesHistoryDto.add(purchaseHistoryDto);
    }
    return purchasesHistoryDto;
  }

  Future<String> postUsersPurchase(
      final PurchaseHistoryDto purchaseHistoryDto) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    final String jsonPayload = purchaseHistoryDto.toJson();
    try {
      final http.Response response = await http.post(
        Uri.parse(this._url),
        headers: headers,
        body: jsonPayload,
      );
      dynamic responseBody = jsonDecode(response.body);
      if (responseBody["statusCode"] == 201) {
        return "New purchase added successfully";
      } else {
        return "Error when adding a new purchase. Error: ${responseBody['body']}";
      }
    } catch (error) {
      return "Could not add a new purchase. Error: ${error}";
    }
  }
}
