import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/questionnaireBackbone.dart'
    show QuestionnaireBackbone;
import 'package:coffee_orderer/utils/fileReaders.dart'
    show loadLlmUpdaterQuestions;
import 'package:coffee_orderer/models/llmUpdaterQuestion.dart'
    show LlmUpdaterQuestion;
import 'package:dartz/dartz.dart' show Either;
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/optionsBox.dart'
    show OptionsBox;

class LLMUpdaterFormularPage extends StatefulWidget {
  @override
  _LLMUpdaterFormularPageState createState() => _LLMUpdaterFormularPageState();
}

class _LLMUpdaterFormularPageState extends State<LLMUpdaterFormularPage> {
  bool _fetchedQuestions;
  List<LlmUpdaterQuestion> _questions;
  int _questionIndex;
  List<String> _selectedOptions;

  _LLMUpdaterFormularPageState() {
    this._questions = [];
    this._selectedOptions = [];
    this._fetchedQuestions = false;
    this._questionIndex = 0;
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
                    (List<LlmUpdaterQuestion> left) => null,
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
    LlmUpdaterQuestion currentQuestion = this._questions[_questionIndex];
    List<String> currentQuestionOptions = currentQuestion.options;
    bool questionnaireFinished = false;
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    currentQuestion.question,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ...OptionsBox(
                      fn: () {
                        setState(() {
                          this
                              ._selectedOptions
                              .add(currentQuestionOptions[_questionIndex]);
                          this._questionIndex >= this._questions.length - 1
                              ? questionnaireFinished = true
                              : this._questionIndex += 1;
                        });
                      },
                      params: {
                        "options": this._selectedOptions,
                        "questionOption": currentQuestionOptions,
                        "questionIndex": this._questionIndex,
                        "questions": this._questions,
                        "questionnaireFinished": questionnaireFinished,
                      },
                      questionnaireFinishedFn: () {
                        return questionnaireFinished;
                      })
                ],
              ),
            ),
          ),
          Text(
            "${this._questionIndex + 1}/${this._questions.length}",
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_questionIndex + 1) / _questions.length,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    ));
  }
}
