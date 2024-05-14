import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:untitled1/MQTT.dart';
import 'package:untitled1/Stt.dart';
import 'package:untitled1/api.dart';
import 'package:untitled1/spotify.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _HomePageState();
}

class _HomePageState extends State<Main> {
  final SpeechToText _speechToText = SpeechToText();
  final List<Widget> _pages = [
   MQTTPage(),
   Stt(),
    Spotify(),
    MyApi(),

  ];
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();

  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }
  void _changePage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );

  }
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
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

            actions: [
              FloatingActionButton(
                onPressed: _speechToText.isListening ? _stopListening : _startListening,
                tooltip: 'Listen',
                child: Icon(
                  _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                  color: Color(0xFF7573C6),
                ),

              ),
            ],

      ),

      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "listening..."
                    : _speechEnabled
                    ? "Tap the microphone to start listening..."
                    : "Speech not available",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _wordsSpoken,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF7573C6),// Yan bölüm rengi
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => _changePage(0),
                          icon: Icon(Icons.wifi, size: 24, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => _changePage(1),
                          icon: Icon(Icons.mic, size: 24, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => _changePage(2),
                          icon: Icon(Icons.music_note, size: 24, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => _changePage(3),
                          icon: Icon(Icons.api, size: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ),
                child: Text(
                  "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),


    );
  }
}
