import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
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
  var text = "Hold the button and start speaking";
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

  final String api_key = "aa972770df9b6a6cec4bc08bb7db363d91413f1229423755caf9819dd7be77e8";
  final String apiUrl = 'https://imp-funny-jennet.ngrok-free.app/';
  double brightnessValue = 50;
  double velocityValue = 0.5;
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
      await launch('url');
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
        actions: [
          IconButton(
            onPressed: () {
              if(_m.isNotEmpty)
              {_launchURL(_m.values.elementAt(5));}
            },
            icon: Icon(Icons.launch,color: Colors.white,),
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
                           // Sabit yükseklik
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
                    width: 200,
                    child: CircleColorPicker(

                      controller: _controller3,
                      onChanged: (color) {
                        setState(() => _currentColor3 = color);
                        _updateValues();
                      },
                      ),
                    ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                        setState(() {
                        _controller2.color = _currentColor;
                        _controller3.color = _currentColor;
                        _currentColor2 = _currentColor;
                        _currentColor3 = _currentColor;
                        });
                    }, icon: Icon(Icons.equalizer, color: bgColor,)
                   
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text('Red1: ${_currentColor.red}', style: TextStyle(color: Colors.red)),
                      SizedBox(width: 20),
                      Text('Green1: ${_currentColor.green}', style: TextStyle(color: Colors.green)),
                      SizedBox(width: 20),
                      Text('Blue1: ${_currentColor.blue}', style: TextStyle(color: Colors.blue)),

                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text('Red2: ${_currentColor2.red}', style: TextStyle(color: Colors.red)),
                      SizedBox(width: 20),
                      Text('Green2: ${_currentColor2.green}', style: TextStyle(color: Colors.green)),
                      SizedBox(width: 20),
                      Text('Blue2: ${_currentColor2.blue}', style: TextStyle(color: Colors.blue)),

                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text('Red3: ${_currentColor3.red}', style: TextStyle(color: Colors.red)),
                      SizedBox(width: 20),
                      Text('Green3: ${_currentColor3.green}', style: TextStyle(color: Colors.green)),
                      SizedBox(width: 20),
                      Text('Blue3: ${_currentColor3.blue}', style: TextStyle(color: Colors.blue)),

                    ],
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
                              max: 100,
                              onChanged: (value) {
                                setState(() {
                                  brightnessValue = value;
                                });
                                _updateValues();

                              },
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
                  Text('Brightness: ${brightnessValue.toStringAsFixed(2)}'),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Text('Velocity: ${velocityValue.toStringAsFixed(2)}'),
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
                  ],
                ),
              ),
                ),]),
              Text('Animation: $_animationName'),
            const SizedBox(height: 15),

                   Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF7573C6)),
                      ),
                      child: Text(
                        receivedMessage ?? 'Bekleniyor...',
                        style: TextStyle(fontSize: 20),
                      ),

                        ),

              const SizedBox(height: 20),

              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0),
              ),

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
                        if(_m.isNotEmpty) {
                          switch(_m.values.elementAt(1).length) {
                            case 1:
                              _controller.color = _m.values.elementAt(1)[0];
                             _currentColor = _m.values.elementAt(1)[0];
                             break;
                            case 2:
                              _controller.color = _m.values.elementAt(1)[0];
                              _controller2.color = _m.values.elementAt(1)[1];
                              _currentColor = _m.values.elementAt(1)[0];
                              _currentColor2 = _m.values.elementAt(1)[1];
                              break;
                            default:
                              _controller.color = _m.values.elementAt(1)[0];
                              _controller2.color = _m.values.elementAt(1)[1];
                              _controller3.color = _m.values.elementAt(1)[2];
                              _currentColor = _m.values.elementAt(1)[0];
                              _currentColor2 = _m.values.elementAt(1)[1];
                              _currentColor3 = _m.values.elementAt(1)[2];
                              break;
                          }
                          brightnessValue = _m.values.elementAt(2);
                          velocityValue = _m.values.elementAt(3);
                          _animationValue = _m.values.elementAt(4);
                        }

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


