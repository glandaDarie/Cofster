import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/options/chooseOption.dart'
    show ChooseOption;
import 'package:coffee_orderer/components/llmUpdaterFormularScreen/options/writeOption.dart'
    show WriteOption;

List<Padding> OptionsBox({
  @required void Function() nextQuestion,
  @required Map<String, dynamic> params,
  @required bool Function() questionnaireFinished,
  @required Map<String, dynamic> Function() collectQuestionnaireResponse,
  BuildContext context,
  StatefulWidget routeBuilder,
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
                nextQuestion: nextQuestion,
                questionnaireFinished: questionnaireFinished,
                collectQuestionnaireResponse: collectQuestionnaireResponse,
                context: context,
                routeBuilder: routeBuilder,
              )
            : WriteOption(
                nextQuestion: nextQuestion,
                questionnaireFinished: questionnaireFinished,
                collectQuestionnaireResponse: collectQuestionnaireResponse,
                context: context,
                routeBuilder: routeBuilder,
              ),
      )
      .toList();
}
