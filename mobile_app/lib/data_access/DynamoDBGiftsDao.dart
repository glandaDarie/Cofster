import 'package:coffee_orderer/models/gift.dart' show Gift;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class DynamoDBGiftsDao {
  final String _url;

  DynamoDBGiftsDao(String url) : this._url = url.trim();

  Future<List<Gift>> getUserGifts() async {
    try {
      final http.Response response = await http.get(Uri.parse(this._url));
      if (response.statusCode == 200) {
        final List<Gift> gifts =
            this._parseJsonUserGifts(jsonDecode(response.body));
        if (gifts == null) {
          ToastUtils.showToast("Error: problems when parsing the JSON");
          return null;
        }
        return gifts;
      }
    } catch (error) {
      throw "Error when trying to fetch the gifts of the user: ${error}";
    }
    return null;
  }

  List<Gift> _parseJsonUserGifts(dynamic jsonUserGifts) {
    final Map<String, dynamic> jsonGifts = jsonUserGifts["gifts"][0];
    List<Gift> gifts = [];
    for (String jsonGift in jsonGifts.keys) {
      gifts.add(Gift(jsonGift));
    }
    return gifts;
  }
}
