// import 'package:flutter/material.dart';

// class QuestionnairePage extends StatefulWidget {
//   @override
//   _QuestionnairePageState createState() => _QuestionnairePageState();
// }

// class _QuestionnairePageState extends State<QuestionnairePage> {
//   QuestionnairePageState() {}

//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

// import 'package:flutter/material.dart';
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
//         title: Text('Question ${_questionIndex + 1}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               questions.keys.elementAt(_questionIndex),
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             ...currentQuestionOptions.map((option) => OptionButton(
//                   text: option,
//                   onPressed: () => _onOptionSelected(option),
//                 )),
//             Spacer(),
//             if (_questionIndex < questions.length - 1)
//               ElevatedButton(
//                 onPressed: () => _onOptionSelected(null),
//                 child: Text('Next'),
//               ),
//             if (_questionIndex == questions.length - 1)
//               ElevatedButton(
//                 onPressed: () => print(_selectedOptions),
//                 child: Text('Submit'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OptionButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   OptionButton({@required this.text, @required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Text(text),
//     );
//   }
// }

// import 'package:flutter/material.dart';
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
//         title: Text('Question ${_questionIndex + 1}'),
//         backgroundColor: Colors.brown,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               questions.keys.elementAt(_questionIndex),
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             ...currentQuestionOptions.map((option) => OptionButton(
//                   text: option,
//                   onPressed: () => _onOptionSelected(option),
//                 )),
//             Spacer(),
//             if (_questionIndex < questions.length - 1)
//               ElevatedButton(
//                 onPressed: () => _onOptionSelected(null),
//                 child: Text('Next'),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.brown,
//                   onPrimary: Colors.white,
//                 ),
//               ),
//             if (_questionIndex == questions.length - 1)
//               ElevatedButton(
//                 onPressed: () => print(_selectedOptions),
//                 child: Text('Submit'),
//                 style: ElevatedButton.styleFrom(
//                   primary: Colors.brown,
//                   onPrimary: Colors.white,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OptionButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   OptionButton({@required this.text, @required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Text(text),
//       style: ElevatedButton.styleFrom(
//         primary: Colors.white,
//         onPrimary: Colors.brown,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 16),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
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
//         backgroundColor: Colors.brown[400],
//         elevation: 0,
//         title: Text(
//           'Question ${_questionIndex + 1}',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.brown[400], Colors.brown[200]],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           questions.keys.elementAt(_questionIndex),
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         ...currentQuestionOptions.map(
//                           (option) => OptionButton(
//                             text: option,
//                             onPressed: () => _onOptionSelected(option),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               if (_questionIndex < questions.length - 1)
//                 ElevatedButton(
//                   onPressed: () => _onOptionSelected(null),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.brown[400],
//                     onPrimary: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Text('Next'),
//                 ),
//               if (_questionIndex == questions.length - 1)
//                 ElevatedButton(
//                   onPressed: () => print(_selectedOptions),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.brown[400],
//                     onPrimary: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Text('Submit'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OptionButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   OptionButton({@required this.text, @required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         primary: Colors.brown[200],
//         onPrimary: Colors.black,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       child: Text(text),
//     );
//   }
// }

import 'package:flutter/material.dart';
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
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentQuestionOptions =
        questions.values.elementAt(_questionIndex);

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text('Question ${_questionIndex + 1}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              questions.keys.elementAt(_questionIndex),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 20),
            ...currentQuestionOptions
                .map((option) => OptionButton(
                      text: option,
                      onPressed: () => _onOptionSelected(option),
                    ))
                .toList(),
            Spacer(),
            if (_questionIndex < questions.length - 1)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[800],
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => _onOptionSelected(null),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            if (_questionIndex == questions.length - 1)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[800],
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () => print(_selectedOptions),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  OptionButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.brown[800],
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
        ),
      ),
    );
  }
}
