import 'package:flutter/material.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart'
    show QuestionnaireController;
import 'package:coffee_orderer/models/question.dart' show Question;

class LLMUpdaterFormularPage extends StatefulWidget {
  @override
  _LLMUpdaterFormularPageState createState() => _LLMUpdaterFormularPageState();
}

class _LLMUpdaterFormularPageState extends State<LLMUpdaterFormularPage> {
  QuestionnaireController _questionnaireController;
  bool _fetchedQuestions;
  List<Question> _questions;

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
            future: llmUpdaterFormularQuestions(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.brown, backgroundColor: Colors.white));
              } else if (snapshot.hasError) {
                return Text(
                    "The formular was not loaded successfully, error: ${snapshot.error}");
              } else {
                List<Question> questions = [...snapshot.data];
                this._fetchedQuestions = true;
                return questionnaireBackbone(
                  title: "Questionnaire",
                  fn: fetchQuestions,
                  params: {"questions": questions},
                );
              }
            },
          )
        : questionnaireBackbone(
            title: "Questionnaire",
            fn: fetchQuestions,
          );
  }

  Scaffold questionnaireBackbone({
    @required String title,
    @required Function fn,
    Map<String, dynamic> params = const {},
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown.shade200, Colors.brown.shade700],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: fn(params: params),
        ),
      ),
    );
  }

  Widget fetchQuestions({Map<String, dynamic> params = const {}}) {
    if (params.length != 0) {
      this._questions = params["questions"];
    }
    print("Display dummy questions: ${this._questions}");
    return Column();
  }
}
