import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/options/chooseOption.dart'
    show ChooseOption;
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/options/writeOption.dart'
    show WriteOption;

List<Padding> OptionsBox({
  @required Map<String, dynamic> params,
  @required BuildContext context,
  @required StatefulWidget routeBuilder,
  @required void Function(String) onNextQuestion,
  @required bool Function() onQuestionnaireFinished,
  @required Map<String, dynamic> Function() onCollectQuestionnaireResponses,
}) {
  List<String> options = [];
  if (params["questionOption"] != null) {
    options = [...params["questionOption"]];
  }
  return options
      .map<Padding>(
        (String option) => option != "None"
            ? ChooseOption(
                option,
                context: context,
                routeBuilder: routeBuilder,
                onNextQuestion: onNextQuestion,
                onQuestionnaireFinished: onQuestionnaireFinished,
                onCollectQuestionnaireResponses:
                    onCollectQuestionnaireResponses,
              )
            : WriteOption(
                context: context,
                routeBuilder: routeBuilder,
                onNextQuestion: onNextQuestion,
                onQuestionnaireFinished: onQuestionnaireFinished,
                onCollectQuestionnaireResponses:
                    onCollectQuestionnaireResponses,
              ),
      )
      .toList();
}
