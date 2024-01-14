import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/patterns/questionnaireLlmUpdaterMqqtPublisherFascade.dart'
    show QuestionnaireLlmUpdaterMqttPublisherFascade;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

Future<void> onPressed({
  @required BuildContext context,
  @required StatefulWidget routeBuilder,
  @required String option,
  @required void Function(String) onNextQuestion,
  @required bool Function() onQuestionnaireFinished,
  @required Map<String, dynamic> Function() onCollectQuestionnaireResponses,
}) async {
  onNextQuestion(option);
  if (onQuestionnaireFinished()) {
    Map<String, dynamic> questionnaireResponses =
        onCollectQuestionnaireResponses();
    if (questionnaireResponses == null) {
      LOGGER.e("Problems when receiving the data.");
      throw (Exception("Problems when receiving the data."));
    }
    // should be added for the emails of the users, not the names,
    // but easier for testing right now (beacuse I am using the same email to create multiple users)
    questionnaireResponses["name"] =
        await LoggedInService.getSharedPreferenceValue("<nameUser>");
    LOGGER.i("user questionnaire name: ${questionnaireResponses["name"]}");
    // send data async to backend using MQTT
    QuestionnaireLlmUpdaterMqttPublisherFascade.publish(
      data: questionnaireResponses,
      messageBrokerName: "test.mosquitto.org",
      topicName: "questionnaire_LLM_updater_topic",
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => routeBuilder,
      ),
    );
  }
}
