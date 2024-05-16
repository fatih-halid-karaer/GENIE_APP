import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:untitled1/MQTT.dart';
import 'package:untitled1/ProfilePage.dart';
import 'package:untitled1/spotify.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _HomePageState();
}

class _HomePageState extends State<Main> {
  var text = "";
  var isListening = false;
  Color bgColor = const Color(0xFF7573C6);
  var auth = 'Basic '+base64Encode(utf8.encode('genie:Alaaddin123'));
  int _animationValue = 0;
  String _animationName = 'No Effect';
  SpeechToText speechToText = SpeechToText();
  void _setAnimationName() {
    switch (_animationValue) {
      case 0:
        _animationName = 'No Effect';
        break;
      case 1:
        _animationName = 'No Effect';
        break;
      case 2:
        _animationName = 'Wave';
        break;
      case 3:
        _animationName = 'Breath';
        break;
      case 4:
        _animationName = 'Lightning';
        break;
      default:
        _animationName = 'Unknown';
        break;
    }
  }
  Map<String, dynamic> _m = {};
  Map<String, dynamic> _m1 = {};

  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );
  final _controller2 = CircleColorPickerController(
    initialColor: Colors.blue,
  );final _controller3 = CircleColorPickerController(
    initialColor: Colors.blue,
  );
  final mqttService = MQTTService();
  final List<Widget> _pages = [
    Spotify(),
    ProfilePage(),
  ];
  String? receivedMessage;

  Color _currentColor = Colors.blue;
  Color _currentColor2 = Colors.blue;
  Color _currentColor3 = Colors.blue;
  String _url = "";
  final String api_key = "aa972770df9b6a6cec4bc08bb7db363d91413f1229423755caf9819dd7be77e8";
  final String apiUrl = 'https://imp-funny-jennet.ngrok-free.app/';
  double brightnessValue = 50;
  double velocityValue = 0.5;
  double _d = 0;
  void _handleMessage(String message) {
    setState(() {
      receivedMessage = message;
    });
  }


  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
    _serverStatus();
    mqttService.connect();
    mqttService.onMessageReceived = _handleMessage;

  }
  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }
  void _updateValues() {
    mqttService.publish(_currentColor.red, _currentColor.green,_currentColor.blue, _currentColor2.red, _currentColor2.green,_currentColor2.blue, _currentColor3.red, _currentColor3.green, _currentColor3.blue, brightnessValue, velocityValue, _animationValue);
    setState(() {

    });
  }
  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        if (kDebugMode) {
          print('Microphone available: $available');
        }
      });
    } else {
      if (kDebugMode) {
        print("The user has denied the use of speech recognition.");
      }
    }
  }

  Future<void> _serverStatus() async {
    final String query_add = "server_status";
    try {
      final response = await http.get(
        Uri.parse(apiUrl + query_add),
        headers: {
          'Content-Type': 'application/json',
          'api_key': '$api_key',
          'Authorization': '$auth',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          String responseBody = utf8.decode(response.bodyBytes);
          _m1 = jsonDecode(responseBody);
          print(_m1);
        });
      } else {
        setState(() {
          String responseBody = utf8.decode(response.bodyBytes);
          _m1 = jsonDecode(responseBody);
          print(_m1);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  Future<void> _launchURL(String url) async {
    try {
      // URL launching code
      await launch(url);
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error as needed
    }
  }
  Future<void> _modelResponse(String? text) async {
    final String query_add = "model_response?text=$text";
    try {
      final response = await http.post(
        Uri.parse(apiUrl + query_add),
        headers: {
          'Content-Type': 'application/json',
          'api_key': '$api_key',
          'Authorization': '$auth',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          String responseBody = utf8.decode(response.bodyBytes);
          _m = jsonDecode(responseBody);
          print(_m);
          print(_m.values.elementAt(5));
          _controller.color = RgbColor(_m.values.elementAt(1)[0][0],_m.values.elementAt(1)[0][1], _m.values.elementAt(1)[0][2]);
          _controller2.color = RgbColor(_m.values.elementAt(1)[1][0],_m.values.elementAt(1)[1][1], _m.values.elementAt(1)[1][2]);
          _controller3.color = RgbColor(_m.values.elementAt(1)[2][0],_m.values.elementAt(1)[2][1], _m.values.elementAt(1)[2][2]);
          _currentColor = RgbColor(_m.values.elementAt(1)[0][0],_m.values.elementAt(1)[0][1], _m.values.elementAt(1)[0][2]);
          _currentColor2 = RgbColor(_m.values.elementAt(1)[1][0],_m.values.elementAt(1)[1][1], _m.values.elementAt(1)[1][2]);
          _currentColor3 = RgbColor(_m.values.elementAt(1)[2][0],_m.values.elementAt(1)[2][1], _m.values.elementAt(1)[2][2]);

          brightnessValue = _m.values.elementAt(2).toDouble();
          velocityValue = _m.values.elementAt(3);
          _animationValue = _m.values.elementAt(4);
          _url =  _m.values.elementAt(5);
        });
      } else {
        setState(() {
          String responseBody = utf8.decode(response.bodyBytes);
          _m = jsonDecode(responseBody);
          print(_m);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  double? _doubleMaker(String text) {
    RegExp regExp = RegExp(r"[-+]?[0-9]*\.?[0-9]+");
    if (regExp.hasMatch(text)) {
      Match? match = regExp.firstMatch(text);
      if (match != null) {
        double result = double.parse(match.group(0)!);
        return result;
      }
    } else {
      return 0;
    }
  }

  void _changePage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7573C6),
        title: Column(
          children: [
            Image.asset('assets/logogen.jpg', width: 70, height: 70),
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.equalizer, color: Colors.white,),
                onPressed: () {
                  setState(() {
                    _controller2.color = _currentColor;
                    _controller3.color = _currentColor;
                    _currentColor2 = _currentColor;
                    _currentColor3 = _currentColor;
                  });
                },
              ),
              IconButton(
                onPressed: () {

                  _launchURL(_url);
                },
                icon: Icon(Icons.launch,color: Colors.white,),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [


                      SizedBox(

                        width: 190,
                        height: 200,
                        child: CircleColorPicker(
                          // Sabit yükseklik
                          controller: _controller,
                          onChanged: (color) {
                            setState(() => _currentColor = color);
                            _updateValues();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        height: 200,
                        child: CircleColorPicker(
                           // Sabit yüksekli
                          controller: _controller2,
                          onChanged: (color) {
                            setState(() => _currentColor2 = color);
                            _updateValues();
                          },
                        ),
                      ),
                    ],


              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 200,
                    width: 190,
                    child: CircleColorPicker(

                      controller: _controller3,
                      onChanged: (color) {
                        setState(() => _currentColor3 = color);
                        _updateValues();
                      },
                      ),
                    ),
                  SizedBox(
                    height: 180,
                    width: 190,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Dairesel şekil
                        border: Border.all(color: Color(0xFF7573C6)),
                        color: bgColor,
                      ),
                      child: Center(
                        child: Text(
                          receivedMessage == null ?   'Bekleniyor...'  : '${_doubleMaker(receivedMessage!)} °C' ,
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ),
                  ),



                ],
              ),

              const SizedBox(height: 30),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.brightness_low_sharp, color: Color(0xFF7573C6)),
                          Expanded(
                           child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 10,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                overlayColor: bgColor.withOpacity(0.3),
                                activeTrackColor: bgColor,
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: bgColor,
                              ),
                            child: Slider(
                              value: brightnessValue,
                              min: 0,
                              max: 255,
                              onChanged: (value) {
                                setState(() {
                                  brightnessValue = value;
                                });
                                _updateValues();

                              },
                            ),
                          ),
                          ),
                          Text('Brightness: ${brightnessValue.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.speed, color: Color(0xFF7573C6)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 10,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                overlayColor: bgColor.withOpacity(0.3),
                                activeTrackColor: bgColor,
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: bgColor,
                              ),
                            child: Slider(
                              value: velocityValue,
                              min: 0,
                              max: 1,
                              onChanged: (value) {
                                setState(() {
                                  velocityValue = value;
                                });
                                _updateValues();
                              },
                            ),
                          ),
                          ),
                          Text('Velocity: ${velocityValue.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 10,),
              Stack(
                children: [
                Container(
                  color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.animation,color: Color(0xFF7573C6)),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 10,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                          overlayColor: bgColor.withOpacity(0.3),
                          activeTrackColor: bgColor,
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: bgColor,
                        ),
                      child: Slider(
                        value: _animationValue.toDouble(),
                        min: 0,
                        max: 4,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() {
                            _animationValue = value.toInt();
                            _setAnimationName();
                          });
                          _updateValues();
                        },
                        activeColor: Color(0xFF7573C6),
                      ),
                    ),
                    ),
                    Text('Animation: $_animationName'),
                  ],
                ),
              ),
                ),]),

            const SizedBox(height: 15),


              const SizedBox(height: 20),

              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),
             SizedBox(height: 15,),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Color(0xFF7573C6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Evenly divides the available space
            IconButton(
              onPressed: () => _changePage(0),
              icon: Icon(Icons.music_note, size: 24, color: Colors.white),
            ),
           // Evenly divides the available space
            IconButton(
              onPressed: () => _changePage(1),
              icon: Icon(Icons.person, size: 24, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        child: GestureDetector(
          onTap: () async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                });
                speechToText.listen(
                  listenFor: const Duration(days: 1),
                  onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                      if (text.toLowerCase().contains('model')) {
                        _modelResponse(text);
                      }
                      if(text.toLowerCase().contains('bir')){
                        _controller2.color = _currentColor;
                        _controller3.color = _currentColor;
                        _currentColor2 = _currentColor;
                        _currentColor3 = _currentColor;
                      }
                    });
                  },
                );
              }
            } else {
              setState(() {
                isListening = false;
              });
              speechToText.stop();
            }
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 30,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  }


