import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';


class ApiService {
  static String? token;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Search artists by name
  static Future<List<dynamic>> searchArtists(String name) async {
    final uri = Uri.parse('$baseUrl/search?artistName=$name');
    final res = await http.get(uri, headers: headers);
    final data = jsonDecode(res.body);
    return data['artists'];
  }

  // Filter artists
  static Future<List<dynamic>> filterArtists({
    String? role,
    String? genre,
    String? gender,
    String? language,
    String? artistExp,
    String? location,
  }) async {
    final queryParams = {
      if (role != null) 'role': role,
      if (genre != null) 'genre': genre,
      if (gender != null) 'gender': gender,
      if (language != null) 'language': language,
      if (artistExp != null) 'artist_exp': artistExp,
      if (location != null) 'location': location,
    };

    final uri = Uri.parse('$baseUrl/search/filter')
        .replace(queryParameters: queryParams);
    final res = await http.get(uri, headers: headers);
    final data = jsonDecode(res.body);
    return data['artists'];
  }

  // Get suggested artists
  static Future<List<dynamic>> getSuggestedArtists() async {
    final uri = Uri.parse('$baseUrl/suggested-artists');
    final res = await http.get(uri, headers: headers);
    final data = jsonDecode(res.body);
    return data['suggested'];
  }

  // Get new releases
  static Future<List<dynamic>> getNewReleases() async {
    final uri = Uri.parse('$baseUrl/new-releases');
    final res = await http.get(uri, headers: headers);
    final data = jsonDecode(res.body);
    return data['releases'];
  }

  // Get messages between 2 users
  static Future<List> getMessages(int user1, int user2) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/messages/$user1/$user2'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load messages");
    }
  }

  // Get conversations list
  static Future<List> getConversations(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/messages/conversations/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load conversations");
    }
  }

  // Mark messages as read
  static Future<void> markAsRead(int senderId, int receiverId) async {
    await http.put(
      Uri.parse('http://10.0.2.2:5000/api/messages/read/$senderId/$receiverId'),
    );
  }
}