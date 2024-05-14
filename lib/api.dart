import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyApi extends StatefulWidget {
  const MyApi({super.key});

  @override
  State<MyApi> createState() => _MyApiState();
}

class _MyApiState extends State<MyApi> {
  final String api_key = "aa972770df9b6a6cec4bc08bb7db363d91413f1229423755caf9819dd7be77e8";
  final String apiUrl = 'http://192.168.1.104:8000/';
  Map<String,dynamic> _m = {};
  Map<String,dynamic> _m1 = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serverStatus();
   _readRequest(1);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7573C6),
        title: Column(
          children: [

            Image.asset('assets/logogen.jpg',width: 70,height: 70),


          ],
        ),),
      body: Center(
        child: SingleChildScrollView(
          child: _m.isEmpty ? Center(child: CircularProgressIndicator())
              : Column(
            children: [
              // Profil resmi

              // Hesap detayları
              Card(
                child: Column(
                  children: [
                    // Kullanıcı adı
                    ListTile(
                      title: Text('TEXT 1'),
                      subtitle: Text(_m.values.elementAt(0)),
                    ),

                    // Ad soyad
                    ListTile(
                      title: Text('TEXT 2'),
                      subtitle: Text(_m.values.elementAt(1)),
                    ),
                    ListTile(
                      title: Text('Server Status'),
                      subtitle: Text(_m1.values.elementAt(0)),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }Future<void> _serverStatus() async {
    final String query_add = "server_status";
    try{
      final response = await http.get(
        Uri.parse(apiUrl + query_add),
        headers: {
          'Content-Type': 'application/json',
          'api_key': '$api_key',
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
  Future<void> _readRequest(int n) async {
    final String query_add = "read_request?value=$n&by=_id";
    try{
      final response = await http.get(
        Uri.parse(apiUrl + query_add),
        headers: {
          'Content-Type': 'application/json',
          'api_key': '$api_key',
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
}
