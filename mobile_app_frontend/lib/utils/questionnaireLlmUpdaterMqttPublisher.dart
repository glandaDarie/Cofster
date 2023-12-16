import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class QuestionnaireLlmUpdaterMqttPublisher {
  MqttServerClient _client;
  QuestionnaireLlmUpdaterMqttPublisher({
    @required final String messageBrokerName,
    final String clientIdentifier,
    final bool logging = false,
    final int keepAlivePeriod = 20,
    final int connectTimeoutPeriod = 2000,
    final void Function(String) onSubscribed = null,
    final void Function() onDisconnected = null,
    final void Function() onConnected = null,
    final void Function() onPong = null,
  }) {
    this._setClientSettings(
      messageBrokerName: messageBrokerName,
      clientIdentifier: clientIdentifier,
      logging: logging,
      keepAlivePeriod: keepAlivePeriod,
      connectTimeoutPeriod: connectTimeoutPeriod,
      onSubscribed: onSubscribed,
      onDisconnected: onDisconnected,
      onConnected: onConnected,
      pongCallback: onPong,
    );
  }

  void _setClientSettings({
    @required final String messageBrokerName,
    final String clientIdentifier,
    final bool logging = false,
    final int keepAlivePeriod = 20,
    final int connectTimeoutPeriod = 2000,
    final void Function(String) onSubscribed = null,
    final void Function() onDisconnected = null,
    final void Function() onConnected = null,
    final void Function() pongCallback = null,
  }) {
    this._client = MqttServerClient(messageBrokerName, clientIdentifier ?? "");
    this._client.keepAlivePeriod = keepAlivePeriod;
    this._client.connectTimeoutPeriod = connectTimeoutPeriod;
    this._client.onDisconnected = onDisconnected;
    this._client.onConnected = onConnected;
    this._client.onSubscribed = onSubscribed;
    this._client.pongCallback = pongCallback;
    this._client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier("Mqtt_MyClientUniqueId")
        .withWillTopic("willtopic")
        .withWillMessage("My Will message")
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
  }

  Future<void> publish({
    @required final String topicName,
    @required final dynamic data,
    final int syncTimeMiliseconds = 100,
    bool clearBuilder = true,
  }) async {
    await this._makeConnectionAndPublishMessage(
      topicName: topicName,
      data: data,
      syncTimeMiliseconds: syncTimeMiliseconds,
      clearBuilder: clearBuilder,
    );
    this._disconnect();
  }

  Future<void> _makeConnectionAndPublishMessage({
    @required final String topicName,
    @required final dynamic data,
    final int syncTimeMiliseconds = 100,
    bool clearBuilder = true,
  }) async {
    try {
      await this._client.connect();
    } on NoConnectionException catch (e) {
      LOGGER.i("client exception - $e");
      this._client.disconnect();
    } on SocketException catch (e) {
      LOGGER.i("socket exception - $e");
      this._client.disconnect();
    }
    if (!(this._client.connectionStatus.state ==
        MqttConnectionState.connected)) {
      LOGGER.i("ERROR:: Mosquitto client connection failed");
      ToastUtils.showToast("ERROR:: Mosquitto client connection failed");
      this._client.disconnect();
      return;
    }
    String convertedData = this._convToString(data);
    if (convertedData == "") {
      LOGGER.e(
          "Type Error: Data could not be converted, please check the data type of the input.");
      return;
    }

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(convertedData);
    try {
      this
          ._client
          .publishMessage(topicName, MqttQos.exactlyOnce, builder.payload);
    } on InvalidTopicException catch (error) {
      LOGGER.e("An error occurred while publishing the message: $error");
      ToastUtils.showToast("Server problems: ${error}");
      return;
    }
    await Future.delayed(Duration(milliseconds: syncTimeMiliseconds));
    print("Sent data to message queue");
    if (clearBuilder) {
      builder.clear();
    }
  }

  String _convToString(dynamic data) {
    if (data is String) {
      return data;
    } else if (data is Map<String, dynamic>) {
      data = data as Map<String, dynamic>;
      List<String> keys = data.keys.toList();
      return keys
          .map(
            (String key) =>
                ["Question: ${key}", "Answer: ${data[key]}"].join(" - "),
          )
          .join("\n");
    }
    return "";
  }

  void _disconnect() {
    try {
      this._client.disconnect();
    } catch (error) {
      LOGGER.i("Could not disconnect, error?: $error");
      return;
    }
  }
}
