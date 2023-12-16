import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/patterns/questionnaireLlmUpdaterMqqtPublisherFascade.dart'
    show QuestionnaireLlmUpdaterMqttPublisherFascade;

Padding WriteOption({
  BuildContext context,
  StatefulWidget routeBuilder,
  @required void Function(String) onNextQuestion,
  @required bool Function() onQuestionnaireFinished,
  @required Map<String, dynamic> Function() onCollectQuestionnaireResponses,
}) {
  final TextEditingController optionTextEditingController =
      TextEditingController();
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
            controller: optionTextEditingController,
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
            String option = optionTextEditingController.text;
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
