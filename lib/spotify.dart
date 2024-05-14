import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class Spotify extends StatefulWidget {
  @override
  _SpotifyState createState() => _SpotifyState();
}

class _SpotifyState extends State<Spotify> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  Future<String> _getAuthToken() async {
    final String clientId = 'f09569bc1fa24bc1a4521005aeeb7a7b';
    final String clientSecret = '59ce8d4c8ac44c4f9ec705f433830f1c';
    final String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  void _searchSpotify(String authToken) async {
    final String query = _searchController.text;

    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/search?q=${query}&type=track"),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body)['tracks']['items'];
      });
    } else {
      print('Failed to load search results: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }
  Future<void> launchURL(String trackId) async {
    try {
      // URL launching code here
      await launch('https://open.spotify.com/track/$trackId');
    } catch (e) {
      print('Error launching URL: $e');
      // Handle the error as needed
    }
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
    ),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a song',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authToken = await _getAuthToken();
                _searchSpotify(authToken);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Buton metninin rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Butonun kenar yuvarlaklığı
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Buton içeriğinin padding'i
              ),
              child: Text('Search',style: TextStyle(color: Colors.white,),),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      launchURL(item['id']);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(item['name']),
                        subtitle: Text(item['artists'][0]['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            launchURL(item['id']);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
