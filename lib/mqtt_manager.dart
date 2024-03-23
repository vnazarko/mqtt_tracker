import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  late MqttServerClient _client;
  final String server;
  final int port;
  final String clientId;

  static String recievedText = 'null';
  static String textTopic = '';

  MqttManager({required this.server, required this.port, required this.clientId, String? username, String? password}) {
    _client = MqttServerClient.withPort(server, clientId, port);
    if (username != null && password != null) {
      _client.logging(on: false);  // Включите логгирование для отладки, если необходимо
      _client.setProtocolV311();  // Используйте setProtocolV311() или setProtocolV31() в зависимости от вашего сервера
      _client.connectTimeoutPeriod = 5000;  // Время ожидания подключения в миллисекундах
      _client.keepAlivePeriod = 20;  // Время в секундах между сообщениями keep-alive
      _client.onDisconnected = onDisconnected;
      _client.onConnected = onConnected;

      _client.connectionMessage = MqttConnectMessage()
          .authenticateAs(username, password)
          .withWillTopic('willtopic')  // Если необходимо, добавьте свой Will Topic
          .withWillMessage('My Will message')
          .startClean()  // Начать без сохраненного состояния сессии
          .withWillQos(MqttQos.atLeastOnce);
    }
  }

  // Методы onConnected, onDisconnected, 
  // onSubscribed, publishMessage, subscribeToTopic и disconnect остаются без изменений

  void setReceivedText(String text) => recievedText = text;
  String getReceivedText() => recievedText;

  void setTextTopic(String? topic) => textTopic = topic!;

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
    _client.subscribe(textTopic, MqttQos.atMostOnce);

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print('Получено сообщение: "$payload" из топика: "${c[0].topic}"');
      setReceivedText(payload);
    });
  }

  // Отправка сообщения
    void publishMessage(String topic, String message) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      if (_client.connectionStatus?.state == MqttConnectionState.connected) { 
        _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
        print('Опубликовано на $topic значение $message');
      } else {
        print('дебик');
      }
    }

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

  // Подписка на топик
  // void subscribeToTopic(String topic) {
  //   if (_client.connectionStatus?.state == MqttConnectionState.connected) { 
  //     _client.subscribe(topic, MqttQos.exactlyOnce);

  //     _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
  //       final message = messages[0].payload;

  //       print('Received message: ${message.toString()}');
  //     });
  //   } else {
  //     print('дебик');
  //   }
  // }

  // void subscribeToTopic(String topic) {
  //   print(1);
  //   if (_client.connectionStatus?.state == MqttConnectionState.connected) { 
  //     print('Успешно подключено $topic');
  //     _client.subscribe(topic, MqttQos.atLeastOnce);

  //     // Устанавливаем обработчик для входящих сообщений
  //     _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  //       final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
  //       final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

  //       print('Получено сообщение: $payload на топике: ${c[0].topic}');
  //     });

  //   } else {
  //     print('Соединение с брокером не установлено');
  //   }
  // }


  // Отключение
  void disconnect() {
    _client.disconnect();
  }

}
