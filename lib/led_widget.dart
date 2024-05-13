import 'package:flutter/material.dart';

class RGBColor {
  int red;
  int green;
  int blue;

  RGBColor({required this.red, required this.green, required this.blue});
}

class RGBWidget extends StatelessWidget {
  final RGBColor color;

  RGBWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    Color ledColor = Color.fromRGBO(color.red, color.green, color.blue, 1);

    return Container(
      width: 40,
      height: 266,
      color: ledColor, // RGB LED'in rengi burada ayarlanıyor
      child: Center(
        child: Text(
          'Temperature',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void main() {
  // Önceden belirlenmiş bir renk seçimi
  RGBColor color = RGBColor(red: 255, green: 0, blue: 0); // Kırmızı renk

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Thermometer Widget'),
      ),
      body: Center(
        child: RGBWidget(color: color),
      ),
    ),
  ));
}
