import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/src/typed_buffer.dart';
class MQTTService {
  late MqttServerClient _client; // Değişiklik burada

  void connect() async {
    _client = MqttServerClient('test.mosquitto.org', ''); // Değişiklik burada
    _client.port = 1883;
    _client.logging(on: true);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('Device00001-AUXFDR-GSUDPT')
        .keepAliveFor(60)
        .withWillTopic('GENGEN_ALI/STATUS')
        .withWillMessage('Disconnected')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    _client.connectionMessage = connMessage;

    try {
      await _client.connect(); // Değişiklik burada
      print('MQTT client connected');
      _client.subscribe('GENGEN_ALI/TEMP-AUXFDR-GSUDPT', MqttQos.atMostOnce);
      _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print("Gelen mesaj: $message");
        // Ana sayfadaki fonksiyonu çağırarak gelen mesajı işleyebilirsiniz.
        _onMessageReceived(message);
      });
    } catch (e) {
      print('MQTT client connection failed - $e');
      _client.disconnect();
    }
  }

  void disconnect() {
    _client.disconnect();
  }

  // Ana sayfadaki fonksiyonu çağırmak için bir callback tanımlayın
  void Function(String) _onMessageReceived = (String message) {};

  // Ana sayfadaki fonksiyonu atayacak bir setter tanımlayın
  set onMessageReceived(void Function(String) onMessageReceived) {
    _onMessageReceived = onMessageReceived;
  }
  void publish(int red1, int green1, int blue1, int red2, int green2, int blue2,int red3, int green3, int blue3, double brightness, double velocity, int animationValue) {
    var message1 = '${brightness.toInt()},';
    var message2 = '$velocity,';
    var message3 = '$animationValue,';
    var message4 =  '$red1,$green1,$blue1,$red2,$green2,$blue2,$red3,$green3,$blue3';
    var fullMessage = message1 + message2 + message3 + message4;
    Uint8Buffer buffer = Uint8Buffer();
    buffer.addAll(utf8.encode(fullMessage));
    _client.publishMessage(
      'GENGEN_ALI/RGB-AUXFDR-GSUDPT',
      MqttQos.atMostOnce,
      buffer,
    );
  }

}