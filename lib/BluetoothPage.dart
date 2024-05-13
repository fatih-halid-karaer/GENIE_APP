import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final mqtt.MqttClient client =
  mqtt.MqttClient('MQTT_BROKER_IP', 'flutter_client');
  late mqtt.MqttConnectionState connectionState;
  Color _currentColor = Colors.white; // Başlangıçta LED rengi

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;

    final mqtt.MqttConnectMessage connectMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(mqtt.MqttQos.atLeastOnce);

    client.connectionMessage = connectMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        connectionState = client.connectionState!;
      });
      client.updates?.listen((List<mqtt.MqttReceivedMessage> event) {
        final mqtt.MqttPublishMessage recMess = event[0].payload;
        final String message = mqtt.MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message);
        print('Received message: $message');
      });
    }
  }

  void _onConnected() {
    print('Connected');
    setState(() {
      connectionState = client.connectionState!;
    });
  }

  void _onDisconnected() {
    print('Disconnected');
    setState(() {
      connectionState = client.connectionState!;
    });
  }

  void _publishColor(Color color) {
    String message = _colorToHex(color);
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(
      'led_control',
      mqtt.MqttQos.exactlyOnce,
      builder.payload!,
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  void _setColor(Color color) {
    setState(() {
      _currentColor = color;
    });
    _publishColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7573C6),
        title: Column(
          children: [

            Image.asset('assets/logogen.jpg',width: 70,height: 70),


          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: _setColor,
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.rgb,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(2.0),
                topRight: const Radius.circular(2.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
