import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const Map<String, String> headers = {"Content-Type": "application/json"};
  String url = "http://192.168.0.132:8000/prediction_drinks";
  const Map<String, String> content = {
    "Question 0": "Light",
    "Question 1": "No",
    "Question 2": "Sugar",
    "Question 3": "50%",
    "Question 4": "short and strong",
    "Question 5": "none of the above",
    "Question 6": "no",
  };
  final String payload = jsonEncode(
    {
      "body": content,
    },
  );
  final http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: payload);
  dynamic jsonResponse = jsonDecode(response.body);
  assert(jsonResponse["statusCode"] == 201,
      "Could not fetch data, error: ${jsonResponse['body']}");
  print(
      "Output: ${jsonResponse["favouriteDrinks"].values.toList().cast<String>()}");
}
