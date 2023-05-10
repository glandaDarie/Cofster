// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:coffee_orderer/utils/questions.dart';

// class QuestionnairePage extends StatefulWidget {
//   @override
//   _QuestionnairePageState createState() => _QuestionnairePageState();
// }

// class _QuestionnairePageState extends State<QuestionnairePage> {
//   int _questionIndex = 0;
//   List<String> _selectedOptions = [];

//   void _onOptionSelected(String option) {
//     setState(() {
//       _selectedOptions.add(option);
//       _questionIndex++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String> currentQuestionOptions =
//         questions.values.elementAt(_questionIndex);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Questionnaire"),
//         centerTitle: true,
//         backgroundColor: Colors.brown,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               questions.keys.elementAt(_questionIndex),
//               style: GoogleFonts.quicksand(
//                 textStyle: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.brown,
//                 ),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             ...currentQuestionOptions.map(
//               (option) => Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: ElevatedButton(
//                   onPressed: () => _onOptionSelected(option),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                   ),
//                   child: Text(
//                     option,
//                     style: GoogleFonts.quicksand(
//                       textStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:coffee_orderer/utils/questions.dart';

// class QuestionnairePage extends StatefulWidget {
//   @override
//   _QuestionnairePageState createState() => _QuestionnairePageState();
// }

// class _QuestionnairePageState extends State<QuestionnairePage> {
//   int _questionIndex = 0;
//   List<String> _selectedOptions = [];

//   void _onOptionSelected(String option) {
//     setState(() {
//       _selectedOptions.add(option);
//       print("Selected options are : ${_selectedOptions}");
//       _questionIndex++;
//     });
//   }

//   void _onPreviousQuestion() {
//     setState(() {
//       _questionIndex--;
//       _selectedOptions.removeLast();
//     });
//   }

//   void _onNextQuestion() {
//     setState(() {
//       _questionIndex++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String> currentQuestionOptions =
//         questions.values.elementAt(_questionIndex);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Questionnaire"),
//         centerTitle: true,
//         backgroundColor: Colors.brown,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               questions.keys.elementAt(_questionIndex),
//               style: GoogleFonts.quicksand(
//                 textStyle: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.brown,
//                 ),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             ...currentQuestionOptions.map(
//               (option) => Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: ElevatedButton(
//                   onPressed: () => _onOptionSelected(option),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.brown,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                   ),
//                   child: Text(
//                     option,
//                     style: GoogleFonts.quicksand(
//                       textStyle: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 if (_questionIndex > 0)
//                   ElevatedButton(
//                     onPressed: _onPreviousQuestion,
//                     child: Text("Back"),
//                   ),
//                 if (_questionIndex < questions.length - 1)
//                   ElevatedButton(
//                     onPressed: _onNextQuestion,
//                     child: Text("Next"),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:coffee_orderer/utils/questions.dart';

// class QuestionnairePage extends StatefulWidget {
//   @override
//   _QuestionnairePageState createState() => _QuestionnairePageState();
// }

// class _QuestionnairePageState extends State<QuestionnairePage> {
//   int _questionIndex = 0;
//   List<String> _selectedOptions = [];

//   void _onOptionSelected(String option) {
//     setState(() {
//       _selectedOptions.add(option);
//       print("Selected options are : ${_selectedOptions}");
//       _questionIndex++;
//     });
//   }

//   void _onPreviousQuestion() {
//     setState(() {
//       _questionIndex--;
//       _selectedOptions.removeLast();
//     });
//   }

//   void _onNextQuestion() {
//     setState(() {
//       _questionIndex++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<String> currentQuestionOptions =
//         questions.values.elementAt(_questionIndex);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Questionnaire"),
//         centerTitle: true,
//         backgroundColor: Colors.brown,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   questions.keys.elementAt(_questionIndex),
//                   style: GoogleFonts.quicksand(
//                     textStyle: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.brown,
//                     ),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 16),
//                 ...currentQuestionOptions.map(
//                   (option) => Padding(
//                     padding: EdgeInsets.symmetric(vertical: 8.0),
//                     child: ElevatedButton(
//                       onPressed: () => _onOptionSelected(option),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.brown,
//                         padding:
//                             EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                       ),
//                       child: Text(
//                         option,
//                         style: GoogleFonts.quicksand(
//                           textStyle: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 if (_questionIndex > 0)
//                   ElevatedButton.icon(
//                     onPressed: _onPreviousQuestion,
//                     icon: Icon(Icons.arrow_back),
//                     label: Text("Back"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown,
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.0),
//                       ),
//                     ),
//                   ),
//                 if (_questionIndex < questions.length - 1)
//                   ElevatedButton.icon(
//                     onPressed: _onNextQuestion,
//                     icon: Icon(Icons.arrow_forward),
//                     label: Text("Next"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown,
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.0),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coffee_orderer/utils/questions.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int _questionIndex = 0;
  List<String> _selectedOptions = [];

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOptions.add(option);
      print("Selected options are : ${_selectedOptions}");
      _questionIndex++;
    });
  }

  void _onPreviousQuestion() {
    setState(() {
      _questionIndex--;
      _selectedOptions.removeLast();
    });
  }

  void _onNextQuestion() {
    setState(() {
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentQuestionOptions =
        questions.values.elementAt(_questionIndex);

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
                      ...currentQuestionOptions.map(
                        (option) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () => _onOptionSelected(option),
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
                      onPressed: _onPreviousQuestion,
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
                      onPressed: _onNextQuestion,
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
