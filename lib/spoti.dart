
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class SpotifyService {
  final String clientId = 'CLIENT_ID';
  final String clientSecret = 'CLIENT_SECRET';

  Future<String> getAuthToken() async {
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

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

  Future<List<dynamic>> searchSpotify(String authToken, String query) async {
    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/search?q=$query&type=playlist"),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['playlists']['items'];
    } else {
      print('Failed to load search results: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }

  Future<void> launchURI(String playlistId) async {
    try {
      await launch('spotify:playlist:$playlistId:play');
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

}
