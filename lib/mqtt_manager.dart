import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  late MqttServerClient _client;
  final String server;
  final int port;
  final String clientId;

  MqttManager({required this.server, required this.port, required this.clientId, String? username, String? password}) {
    _client = MqttServerClient.withPort(server, clientId, port);
    if (username != null && password != null) {
      _client.logging(on: false);
      _client.setProtocolV311();
      _client.connectTimeoutPeriod = 5000;
      _client.keepAlivePeriod = 20;
      _client.onDisconnected = onDisconnected;
      _client.onConnected = onConnected;

      _client.connectionMessage = MqttConnectMessage()
          .authenticateAs(username, password)
          .withWillTopic('willtopic')
          .withWillMessage('My Will message')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
    }
  }

  // Методы onConnected, onDisconnected, 
  // onSubscribed, publishMessage, subscribeToTopic и disconnect остаются без изменений

  Future<void> connect() async {
    try {
      print('Попытка подключения к MQTT серверу...');
      await _client.connect();
    } on NoConnectionException catch (e) {
      // Когда исключение вызывается из-за отсутствия подключения
      print('Ошибка подключения - no connection: $e');
      _client.disconnect();
    } on SocketException catch (e) {
      // Когда исключение вызывается из-за ошибки сокета
      print('Ошибка подключения - socket exception: $e');
      _client.disconnect();
    } catch (e) {
      // Любое другое исключение
      print('Неизвестная ошибка подключения: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Успешно подключено к $server');
    } else {
      print('Ошибка подключения: ${_client.connectionStatus}');
      _client.disconnect();
    }

    // Подписываемся на обновления после успешного подключения
    if (_client.connectionStatus?.state == MqttConnectionState.connected) { 
      _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('Получено сообщение: "$payload" из топика: "${c[0].topic}"');
      });
    }
  }

  void startListening() {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      Timer.periodic(Duration(seconds: 1), (Timer t) {
        // В этом месте код для считывания данных
        // В данном контексте просто поддерживаем соединение
        print('Соединение активно: ${DateTime.now()}');
        // Для реального приложения скорее всего надо будет вызывать метод subscribeToTopic или подобные,
        // Зависит от специфики задачи
      });
    }
  }

  // Отправка сообщения
  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
  // Обработчики событий
  void onConnected() {
    print('Подключено к MQTT');
    startListening();
  }

  void onDisconnected() {
    print('Отключено от MQTT');
  }

  void onUnsubscribed(String? topic) {
    print('Отписано от топика: $topic');
  }

  void onSubscribeFail(String topic) {
    print('Ошибка подписки на топик: $topic');
  }

  // Подписка на топик
  void subscribeToTopic(String topic) {
    if (_client.connectionStatus?.state == MqttConnectionState.connected) { 
      print('Успешно');
      _client.subscribe(topic, MqttQos.atLeastOnce);
    } else {
      print('123');
    }
  }

  // Отключение
  void disconnect() {
    _client.disconnect();
  }

}
