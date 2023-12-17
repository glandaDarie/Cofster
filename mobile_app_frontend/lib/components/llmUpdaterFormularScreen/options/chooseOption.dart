import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/optionCallbacks.dart' show onPressed;

Padding ChooseOption(
  String option, {
  @required void Function(String) onNextQuestion,
  @required bool Function() onQuestionnaireFinished,
  @required Map<String, dynamic> Function() onCollectQuestionnaireResponses,
  BuildContext context,
  StatefulWidget routeBuilder,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 48.0,
      child: ElevatedButton(
        onPressed: () {
          onPressed(
            context: context,
            routeBuilder: routeBuilder,
            option: option,
            onNextQuestion: onNextQuestion,
            onQuestionnaireFinished: onQuestionnaireFinished,
            onCollectQuestionnaireResponses: onCollectQuestionnaireResponses,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
