import 'package:coffee_orderer/controllers/QuestionnaireController.dart';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';
import 'package:coffee_orderer/models/question.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  QuestionnaireController questionnaireController;
  UserController userController;
  int _questionIndex;
  List<String> _selectedOptions;
  List<Question> _questions;
  bool _fetchedQuestions = false;

  _QuestionnairePageState() {
    _questionIndex = 0;
    _selectedOptions = [];
    questionnaireController = QuestionnaireController();
    userController = UserController();
  }

  Future<void> _fetchQuestions() async {
    _questions = await questionnaireController.getAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (!_fetchedQuestions) {
      return FutureBuilder(
        future: _fetchQuestions(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Colors.brown, backgroundColor: Colors.white));
          } else {
            if (_questionIndex < _questions.length) {
              _fetchedQuestions = true;
            }
            return Scaffold(
              appBar: AppBar(
                title: Text("Questionnaire"),
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
                  child: _buildQuestionWidget(),
                ),
              ),
            );
          }
        },
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Questionnaire"),
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
            child: _buildQuestionWidget(),
          ),
        ),
      );
    }
  }

  Widget _buildQuestionWidget() {
    Question currentQuestion = _questions[_questionIndex];
    List<String> currentQuestionOptions = currentQuestion.getOptions();
    bool questionnaireFinished = false;
    return Column(
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
                ...currentQuestionOptions.map(
                  (option) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _selectedOptions.add(option);
                          _questionIndex >= _questions.length - 1
                              ? questionnaireFinished = true
                              : _questionIndex += 1;
                        });
                        if (questionnaireFinished) {
                          Map<String, String> selectedOptionsForClassifier = {};
                          for (int i = 0; i < _selectedOptions.length; ++i) {
                            selectedOptionsForClassifier["Question ${i}"] =
                                _selectedOptions[i].toLowerCase();
                          }
                          List<String> fetchedFavouriteDrinks =
                              await questionnaireController
                                  .postQuestionsToGetPredictedFavouriteDrinks(
                                      selectedOptionsForClassifier);
                          Map<String, String> favouriteDrinks =
                              fetchedFavouriteDrinks.asMap().map((key, value) =>
                                  MapEntry("drink ${key + 1}", value));
                          String response = await userController
                              .updateUsersFavouriteDrinks(favouriteDrinks);
                          if (response !=
                              "Successfully updated the favourite drinks") {
                            Fluttertoast.showToast(
                                msg: response,
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor:
                                    Color.fromARGB(255, 102, 33, 12),
                                textColor: Color.fromARGB(255, 220, 217, 216),
                                fontSize: 16);
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.brown,
                                    backgroundColor: Colors.white));
                          }
                          Map<String, String> convertedFavouriteDrinks =
                              favouriteDrinks.map((key, value) {
                            String newKey = key.replaceAll(" ", "-");
                            String newValue = value.replaceAll(" ", "-");
                            return MapEntry(newKey, newValue);
                          });
                          await storeUserInformationInCache(
                              convertedFavouriteDrinks);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                          return null;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          "${_questionIndex + 1}/${_questions.length}",
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
    );
  }
}
