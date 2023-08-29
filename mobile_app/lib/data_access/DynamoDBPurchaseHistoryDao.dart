import 'package:flutter/material.dart';
import 'package:coffee_orderer/data_transfer/PurchaseHistoryDto.dart'
    show PurchaseHistoryDto;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class DynamoDBPurchaseHistoryDao {
  final String _url;

  DynamoDBPurchaseHistoryDao(String url) : this._url = url.trim();

  Future<PurchaseHistoryDto> getUsersPurchaseHistory() async {
    try {
      http.Response response = await http.get(Uri.parse(this._url));
      if (response.statusCode == 200) {
        PurchaseHistoryDto purchaseHistory =
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

  PurchaseHistoryDto _parseJsonUsersPurchaseHistory(dynamic json) {
    return null; // dummy for now
  }

  Future<String> postUsersPurchase(
      final PurchaseHistoryDto purchaseHistoryDto) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    final String jsonPayload = purchaseHistoryDto.toJsonString();
    try {
      final http.Response response = await http.post(
        Uri.parse(this._url),
        headers: headers,
        body: jsonPayload,
      );
      if (response.statusCode == 201) {
        return "New purchase added successfully";
      } else {
        return "Error when adding a new purchase. Status Code: ${response.statusCode}";
      }
    } catch (error) {
      return "Could not add a new purchase. Error: ${error}";
    }
  }
}
