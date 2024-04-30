import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  late MqttServerClient client;
  final String server;
  final int port;
  final String clientId;

  static Map<String, String> recievedText = {
    'Topic': 'null',
    'Text': 'null' 
  };
  static String textTopic = '';

  MqttManager({required this.server, required this.port, required this.clientId, String? username, String? password}) {
    client = MqttServerClient.withPort(server, clientId, port);
    if (username != null && password != null) {
      client.logging(on: false);  // Включите логгирование для отладки, если необходимо
      client.setProtocolV311();  // Используйте setProtocolV311() или setProtocolV31() в зависимости от вашего сервера
      client.connectTimeoutPeriod = 5000;  // Время ожидания подключения в миллисекундах
      client.keepAlivePeriod = 20;  // Время в секундах между сообщениями keep-alive
      client.onDisconnected = onDisconnected;
      client.onConnected = onConnected;

      client.connectionMessage = MqttConnectMessage()
          .authenticateAs(username, password)
          .withWillTopic('willtopic')  // Если необходимо, добавьте свой Will Topic
          .withWillMessage('My Will message')
          .startClean()  // Начать без сохраненного состояния сессии
          .withWillQos(MqttQos.atLeastOnce);
    }
  }

  // Методы onConnected, onDisconnected, 
  // onSubscribed, publishMessage, subscribeToTopic и disconnect остаются без изменений

  void setReceivedText(String topic, String text) { 
    recievedText['Topic'] = topic; 
    recievedText['Text'] = text; 
  }
  Map<String, String> getReceivedText() => recievedText;

  void setTextTopic(String? topic) => textTopic = topic!;

  Future<void> connect() async {
    try {
      print('Попытка подключения к MQTT серверу...');
      await client.connect();
    } on NoConnectionException catch (e) {
      // Когда исключение вызывается из-за отсутствия подключения
      print('Ошибка подключения - no connection: $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Когда исключение вызывается из-за ошибки сокета
      print('Ошибка подключения - socket exception: $e');
      client.disconnect();
    } catch (e) {
      // Любое другое исключение
      print('Неизвестная ошибка подключения: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Успешно подключено к $server');
    } else {
      print('Ошибка подключения: ${client.connectionStatus}');
      client.disconnect();
    }
  }

  // Отправка сообщения
  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (client.connectionStatus?.state == MqttConnectionState.connected) { 
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print('Опубликовано на $topic значение $message');
    } else {
      print('неа');
    }
  }

  void subscribe(List<String> topics) {
    for (final topic in topics) {
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        client.subscribe(topic, MqttQos.atMostOnce);
      } else {
        print('неа1');
      }
    }
  }
  void handleMessage(MqttServerClient client) {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String topic = c[0].topic;
      final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('Получено сообщение: $message с топика $topic');
      setReceivedText(topic, message);
    });
  }

  bool isConnected() => client.connectionStatus?.state == MqttConnectionState.connected;
  // Обработчики событий
  void onConnected() {
    print('Подключено к MQTT');
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

  // Отключение
  void disconnect() {
    client.disconnect();
  }

}
