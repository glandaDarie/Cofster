import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/patterns/questionnaireLlmUpdaterMqqtPublisherFascade.dart'
    show QuestionnaireLlmUpdaterMqttPublisherFascade;

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
          onNextQuestion(option);
          if (onQuestionnaireFinished()) {
            Map<String, dynamic> questionnaireResponses =
                onCollectQuestionnaireResponses();
            if (questionnaireResponses == null) {
              LOGGER.e("Problems when receiving the data.");
              throw (Exception("Problems when receiving the data."));
            }
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
