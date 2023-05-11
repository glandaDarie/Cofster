import 'package:coffee_orderer/models/question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DynamoDBQuestionnaireDao {
  String _url;

  DynamoDBQuestionnaireDao(String url) {
    this._url = url;
  }

  Future<List<Question>> getAllQuestions() async {
    List<Question> questions;
    http.Response response = await http.get(Uri.parse(this._url));
    if (response.statusCode == 200) {
      questions = parseJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
    return questions;
  }

  List<Question> parseJson(List<String> json) {
    return null;
  }
}
