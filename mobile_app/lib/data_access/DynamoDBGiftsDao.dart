import 'package:coffee_orderer/models/gift.dart' show Gift;
import 'package:http/http.dart' as http;
import 'dart:convert';

class DynamoDBGiftsDao {
  final String _url;

  DynamoDBGiftsDao(String url) : this._url = url.trim();

  Future<dynamic> getUserGifts() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(this._url));
      if (response.statusCode == 200) {
        final List<Gift> gifts =
            this._parseJsonUserGifts(jsonDecode(response.body));
        if (gifts == null) {
          return "Error: problems when parsing the JSON";
        }
        return gifts;
      }
    } catch (error) {
      return "Error when trying to fetch the gifts of the user: ${error}";
    }
    return "Problem when fetching the gifts from the backend. Body: ${response.body}";
  }

  List<Gift> _parseJsonUserGifts(dynamic jsonUserGifts) {
    final Map<String, dynamic> jsonGifts = jsonUserGifts["gifts"][0];
    List<Gift> gifts = [];
    for (String jsonGift in jsonGifts.values) {
      gifts.add(Gift(jsonGift));
    }
    return gifts;
  }

  Future<String> createGift(String name, String username, String gift) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    final String payload = jsonEncode({
      "name": name,
      "username": username,
      "gift": gift,
    });
    try {
      final http.Response response = await http.post(
        Uri.parse(this._url),
        headers: headers,
        body: payload,
      );
      dynamic responseBody = jsonDecode(response.body);
      if (responseBody["statusCode"] == 201) {
        return null;
      } else {
        return "Error when adding a new gift. Error: ${responseBody['body']}";
      }
    } catch (error) {
      return "Could not add a new gift. Error: ${error}";
    }
  }

  Future<String> deleteUserGift(
      String name, String username, String gift) async {
    const Map<String, String> headers = {"Content-Type": "application/json"};
    final String payload = jsonEncode({
      "name": name,
      "username": username,
      "gift": gift,
    });
    try {
      final http.Response response = await http.delete(
        Uri.parse(this._url),
        headers: headers,
        body: payload,
      );
      dynamic responseBody = jsonDecode(response.body);
      if (responseBody["statusCode"] == 200) {
        return null;
      } else {
        return "Error when deleting the gift : ${gift}. Error: ${responseBody['body']}";
      }
    } catch (error) {
      return "Could not add a new gift. Error: ${error}";
    }
  }
}
