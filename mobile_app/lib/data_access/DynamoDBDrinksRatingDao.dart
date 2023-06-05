import 'package:http/http.dart' as http;

class DynamoDBDrinksRatingDao {
  String _url;

  DynamoDBDrinksRatingDao(String url) {
    this._url = url;
  }

  Future<String> updateRatingResponseGivenDrink() async {
    String msg = null;
    this._url = this._url.trim();
    try {
      http.Response response = await http.put(Uri.parse(this._url));
      if (response.statusCode == 200) {
        msg = response.body;
      }
    } catch (error) {
      msg = "Error: ${error}";
    }
    return msg;
  }

  Future<String> getDrinkRating() async {
    String data;
    this._url = this._url.trim();
    try {
      http.Response response = await http.get(Uri.parse(this._url));
      if (response.statusCode == 200) {
        data = response.body;
      }
    } catch (error) {
      data = error.toString();
    }
    return data;
  }
}
