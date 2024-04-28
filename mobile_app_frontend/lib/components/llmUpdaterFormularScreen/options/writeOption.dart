import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/optionCallbacks.dart' show onPressed;

Padding WriteOption({
  BuildContext context,
  StatefulWidget routeBuilder,
  @required void Function(String) onNextQuestion,
  @required bool Function() onQuestionnaireFinished,
  @required
      Future<Map<String, String>> Function() onCollectQuestionnaireResponses,
}) {
  final TextEditingController optionTextEditingController =
      TextEditingController();

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.brown, width: 1.0),
          ),
          child: TextField(
            controller: optionTextEditingController,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            textInputAction: TextInputAction.newline,
            maxLines: 30,
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
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
        ElevatedButton(
          onPressed: () {
            onPressed(
              context: context,
              routeBuilder: routeBuilder,
              option: optionTextEditingController.text,
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
