import 'package:flutter/material.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart'
    show QuestionnaireController;
import 'package:coffee_orderer/models/question.dart' show Question;
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/questionnaireBackbone.dart'
    show QuestionnaireBackbone;
import 'package:coffee_orderer/utils/fileReaders.dart'
    show loadLlmUpdaterQuestions;
import 'package:coffee_orderer/models/llmUpdaterQuestion.dart'
    show LlmUpdaterQuestion;
import 'package:dartz/dartz.dart' show Either;

class LLMUpdaterFormularPage extends StatefulWidget {
  @override
  _LLMUpdaterFormularPageState createState() => _LLMUpdaterFormularPageState();
}

class _LLMUpdaterFormularPageState extends State<LLMUpdaterFormularPage> {
  QuestionnaireController _questionnaireController;
  bool _fetchedQuestions;
  List<LlmUpdaterQuestion> _questions;

  _LLMUpdaterFormularPageState() {
    this._questionnaireController = QuestionnaireController();
    this._questions = [];
    this._fetchedQuestions = false;
  }

  Future<List<Question>> llmUpdaterFormularQuestions() async {
    return await this._questionnaireController.getAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return !this._fetchedQuestions
        ? FutureBuilder(
            future: loadLlmUpdaterQuestions("llmUpdaterQuestions.txt"),
            builder: (BuildContext context,
                AsyncSnapshot<Either<List<LlmUpdaterQuestion>, String>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.brown, backgroundColor: Colors.white));
              } else if (snapshot.hasError) {
                return Text(
                    "The formular was not loaded successfully, error: ${snapshot.error}");
              } else {
                if (snapshot.data.isRight()) {
                  snapshot.data.fold(
                    (List<LlmUpdaterQuestion> left) => "",
                    (String right) => throw (Exception(right)),
                  );
                }
                List<LlmUpdaterQuestion> left = snapshot.data.fold(
                  (List<LlmUpdaterQuestion> left) => left,
                  (String right) => throw (Exception(right)),
                );
                List<LlmUpdaterQuestion> questions = [...left];
                this._fetchedQuestions = true;
                return QuestionnaireBackbone(
                  title: "Questionnaire",
                  fn: fetchQuestions,
                  params: {"questions": questions},
                );
              }
            },
          )
        : QuestionnaireBackbone(
            title: "Questionnaire",
            fn: fetchQuestions,
          );
  }

  Widget fetchQuestions({Map<String, dynamic> params = const {}}) {
    if (params.length != 0) {
      this._questions = params["questions"];
    }
    for (LlmUpdaterQuestion question in this._questions) {
      print("Question: ${question.question}");
      print("Options: ${question.options}");
    }
    // do the questionnaire UI part here
    return Column();
  }
}
