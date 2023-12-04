import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:coffee_orderer/utils/constants.dart' show FILES_PATH;
import 'package:path/path.dart' as path;
import 'package:coffee_orderer/models/llmUpdaterQuestion.dart'
    show LlmUpdaterQuestion;
import 'package:dartz/dartz.dart' show Either, left, right;

Future<String> generateFunFact(String file) async {
  String funFact = null;
  try {
    String fileContent = await readFileContent(file: file);
    if (fileContent
        .toLowerCase()
        .contains("Error reading file".toLowerCase())) {
      return fileContent;
    }
    List<String> lines = fileContent.split("\n");
    Random random = Random();
    int randomIndex = random.nextInt(lines.length);
    funFact = lines[randomIndex];
  } catch (error) {
    return "Error when fetching the content from the file, error: $error";
  }
  return funFact;
}

Future<Either<List<LlmUpdaterQuestion>, String>> loadLlmUpdaterQuestions(
    String file) async {
  List<LlmUpdaterQuestion> llmUpdaterQuestios = [];
  try {
    String fileContent = await readFileContent(file: file);
    if (fileContent
        .toLowerCase()
        .trim()
        .contains("Error reading file".trim().toLowerCase())) {
      return right(fileContent);
    }
    List<String> lines = fileContent.split("\n");
    assert(lines.length % 2 == 0,
        "There is a problem in the file: $file. Please make sure there is a question and an option present.");
    LlmUpdaterQuestion llmUpdaterQuestion;
    for (int i = 0; i < lines.length; i += 2) {
      String question = lines[i].split(": ")[1];
      List<String> options = lines[i + 1].split(": ")[1].split(", ");
      llmUpdaterQuestion = LlmUpdaterQuestion(question, options);
      llmUpdaterQuestios.add(llmUpdaterQuestion);
    }
  } catch (error) {
    return right(error.toString());
  }
  return left(llmUpdaterQuestios);
}

Future<String> readFileContent({@required String file}) async {
  String content = null;
  try {
    String filePath = path.join(FILES_PATH, file);
    content = await rootBundle.loadString(filePath);
  } catch (error) {
    content = "Error reading file: $error";
  }
  return content;
}
