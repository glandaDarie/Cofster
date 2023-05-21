import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/question.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
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
      questions = parseJsonGetAllQuestions(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch data");
    }
    return questions;
  }

  List<Question> parseJsonGetAllQuestions(List<dynamic> json) {
    if (json == null || json.isEmpty) {
      throw Exception("JSON is null or empty");
    }
    List<Question> outQuestions = [];
    List<dynamic> questions = json[0]["questions"];
    for (int i = 0; i < questions.length - 2; i += 2) {
      String question = questions[i]["question"];
      List<String> options = List<String>.from(questions[i + 1]["options"]);
      outQuestions.add(Question(question: question, options: options));
    }
    return outQuestions;
  }

  Future<List<String>> postQuestionsToGetPredictedFavouriteDrinks(
      Map<String, String> content) async {
    dynamic jsonResponse = null;
    Map<String, dynamic> requestBody = {"body": content};
    try {
      http.Response response = await http.post(Uri.parse(this._url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody));
      jsonResponse = jsonDecode(response.body);
      if (jsonResponse["statusCode"] != 201) {
        Fluttertoast.showToast(
            msg: "Error: ${jsonResponse["body"]}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Color.fromARGB(255, 102, 33, 12),
            textColor: Color.fromARGB(255, 220, 217, 216),
            fontSize: 16);
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Exception when inserting a new user: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    return jsonResponse["favouriteDrinks"].values.toList().cast<String>();
  }
}
