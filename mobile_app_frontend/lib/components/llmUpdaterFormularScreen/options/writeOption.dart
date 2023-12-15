import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;

Padding WriteOption({
  @required void Function() nextQuestion,
  @required bool Function() questionnaireFinished,
  @required Map<String, dynamic> Function() collectQuestionnaireResponse,
  BuildContext context,
  StatefulWidget routeBuilder,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.brown, width: 1.0),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: "Enter text here",
              hintStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              border: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 225.0),
        ),
        ElevatedButton(
          onPressed: () {
            nextQuestion();
            if (questionnaireFinished()) {
              Map<String, dynamic> questionnaireResponse =
                  collectQuestionnaireResponse();
              if (questionnaireResponse == null) {
                LOGGER.e("Problems when reciving the data.");
                throw (Exception("Problems when reciving the data."));
              }
              print("Questionnaire response: ${questionnaireResponse.values}");
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
            minimumSize: Size(320.0, 50.0),
          ),
          child: Text(
            "Save",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}
