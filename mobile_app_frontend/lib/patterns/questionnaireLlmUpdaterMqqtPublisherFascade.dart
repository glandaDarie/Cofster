import 'package:coffee_orderer/utils/questionnaireLlmUpdaterMqttPublisher.dart'
    show QuestionnaireLlmUpdaterMqttPublisher;
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:flutter/material.dart';

class QuestionnaireLlmUpdaterMqttPublisherFascade {
  static void publish({
    @required dynamic data,
    @required String messageBrokerName,
    @required String topicName,
  }) {
    QuestionnaireLlmUpdaterMqttPublisher questionnaireLlmUpdaterMqttPublisher =
        QuestionnaireLlmUpdaterMqttPublisher(
      messageBrokerName: messageBrokerName,
      onSubscribed: (String topicName) {
        LOGGER.i("Successfully subscribed to topic: ${topicName}");
      },
      onDisconnected: () {
        LOGGER.i("OnDisconnected client callback - Client disconnection");
      },
      onConnected: () {
        LOGGER.i(
            "OnConnected client callback - Client connection was successful");
      },
      onPong: () {
        LOGGER.i("Ping response client callback invoked");
      },
    );
    questionnaireLlmUpdaterMqttPublisher.publish(
      topicName: topicName,
      data: data,
    );
  }
}
