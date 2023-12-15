import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class QuestionnaireLlmUpdaterMqttProducer {
  MqttServerClient _client;
  QuestionnaireLlmUpdaterMqttProducer({
    @required String messageBrokerName,
    final bool logging = false,
    final int keepAlivePeriod = 20,
    final int connectTimeoutPeriod = 2000,
    final Function onDisconnected = null,
    final Function onConnected = null,
    final Function onSubscribed = null,
    final Function pongCallback = null,
  }) {
    this._setClientSettings(
      messageBrokerName: messageBrokerName,
      logging: logging,
      keepAlivePeriod: keepAlivePeriod,
      connectTimeoutPeriod: connectTimeoutPeriod,
      onDisconnected: onDisconnected,
      onConnected: onConnected,
      onSubscribed: onSubscribed,
      pongCallback: pongCallback,
    );
  }

  void _setClientSettings({
    @required String messageBrokerName,
    final bool logging = false,
    final int keepAlivePeriod = 20,
    final int connectTimeoutPeriod = 2000,
    final Function onDisconnected = null,
    final Function onConnected = null,
    final Function onSubscribed = null,
    final Function pongCallback = null,
  }) {
    this._client = _client;
    this._client = MqttServerClient(messageBrokerName, '');
    this._client.keepAlivePeriod = keepAlivePeriod;
    this._client.connectTimeoutPeriod = connectTimeoutPeriod;
    this._client.onDisconnected = onDisconnected;
    this._client.onConnected = onConnected;
    this._client.onSubscribed = onSubscribed;
    this._client.pongCallback = pongCallback;
    this._client.connectionMessage = MqttConnectMessage().startClean();
  }

  Future<void> makeConnection({
    @required final String topicName,
    @required final String data,
    bool retainData = false,
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

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(data);
    this
        ._client
        .publishMessage(topicName, MqttQos.exactlyOnce, builder.payload);
    if (!retainData) {
      builder.clear();
    }
  }

  void disconnect() {
    try {
      this._client.disconnect();
    } catch (error) {
      LOGGER.i("Could not disconnect, error?: $error");
      return;
    }
  }
}
