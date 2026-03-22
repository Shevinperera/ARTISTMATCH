import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<List> getMessages(int user1, int user2) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/messages/$user1/$user2"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load messages");
    }
  }

 static Future<void> sendMessage({
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/messages"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to send message");
    }
  }

  // GET conversations list
static Future<List> getConversations(int userId) async {
  final response = await http.get(
    Uri.parse("$baseUrl/api/messages/conversations/$userId"),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load conversations");
  }
}

// MARK messages as read
static Future<void> markAsRead(int senderId, int receiverId) async {
  await http.put(
    Uri.parse("$baseUrl/api/messages/read/$senderId/$receiverId"),
  );
}
}

  