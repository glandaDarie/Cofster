import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Padding ChooseOption(
  String option, {
  @required void Function() nextQuestion,
  @required bool Function() questionnaireFinished,
  @required Map<String, dynamic> Function() collectQuestionnaireResponse,
  BuildContext context,
  StatefulWidget routeBuilder,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton(
      onPressed: () {
        nextQuestion();
        if (questionnaireFinished()) {
          Map<String, dynamic> questionnaireResponse =
              collectQuestionnaireResponse();
          if (questionnaireResponse == null) {}
          print("Questionnaire response: ${questionnaireResponse}");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => routeBuilder,
            ),
          );
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
  );
}
