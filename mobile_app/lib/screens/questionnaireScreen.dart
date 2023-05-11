import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_orderer/utils/questions.dart';
import 'package:coffee_orderer/screens/mainScreen.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int _questionIndex;
  List<String> _selectedOptions;
  List<String> _currentQuestionOptions;

  _QuestionnairePageState() {
    _questionIndex = 0;
    _selectedOptions = [];
    _currentQuestionOptions = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_questionIndex < questions.length) {
      _currentQuestionOptions = questions.values.elementAt(_questionIndex);
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
                        questions.keys.elementAt(_questionIndex),
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
                      ..._currentQuestionOptions.map(
                        (option) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_questionIndex >= questions.length - 1) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                                return;
                              }
                              setState(() {
                                _selectedOptions.add(option);
                                _questionIndex += 1;
                              });
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
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_questionIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _questionIndex -= 1;
                          _selectedOptions.removeLast();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown,
                        minimumSize: Size(48, 48),
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  if (_questionIndex < questions.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        if (_questionIndex >= questions.length - 1) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                          return;
                        }
                        setState(() {
                          _questionIndex += 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown,
                        minimumSize: Size(48, 48),
                      ),
                      child: Icon(Icons.arrow_forward),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
