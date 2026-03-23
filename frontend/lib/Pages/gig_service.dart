import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
class GigService {
  // ── Change this to your machine's local IP when testing on a real device
  // Android emulator  → 10.0.2.2
  // iOS simulator     → 127.0.0.1
  // Real device       → e.g. 192.168.1.5  (your PC's LAN IP)
  static const String baseUrl = 'https://artistmatch-backend-production.up.railway.app/api/gigs';
 
  // ── Color rotation for gig cards (since DB doesn't store colors) ──────────
  static const List<Color> _cardColors = [
    Colors.teal,
    Colors.indigo,
    Colors.deepPurple,
    Colors.brown,
    Colors.blueGrey,
    Colors.cyan,
  ];
 
  // ── POST a new gig to Express backend ─────────────────────────────────────
  // gigData keys must match what gigs.routes.js expects:
  //   eventTitle, venue, date (YYYY-MM-DD), time (HH:MM), genre, pay
  static Future<bool> postGig(Map<String, String> gigData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(gigData),
      ).timeout(const Duration(seconds: 10));
 
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('GigService.postGig error: $e');
      return false;
    }
  }
 
  // ── GET all gigs from Express backend ─────────────────────────────────────
  // Maps DB column names → Flutter-friendly keys used by GigPostPage
  static Future<List<Map<String, dynamic>>> fetchGigs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
 
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
 
        return data.asMap().entries.map((entry) {
          final i   = entry.key;
          final gig = entry.value as Map<String, dynamic>;
 
          // Combine event_date + event_time into one readable string
          final rawDate = gig["event_date"]?.toString() ?? "";
          final rawTime = gig["event_time"]?.toString() ?? "";
          final displayDate = _formatDate(rawDate, rawTime);
 
          return <String, dynamic>{
            "title":    gig["event_title"] ?? "Untitled",
            "location": gig["venue"]       ?? "Unknown",
            "date":     displayDate,
            "price":    "Rs ${gig["pay"]   ?? "0"}",
            "color":    _cardColors[i % _cardColors.length],
          };
        }).toList();
      }
 
      debugPrint('GigService.fetchGigs: status ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('GigService.fetchGigs error: $e');
      return [];
    }
  }
 
  // ── Formats "2025-01-15" + "19:00" → "Jan 15, 7:00 PM" ──────────────────
  static String _formatDate(String date, String time) {
    try {
      final dt = DateTime.parse("${date}T$time");
      final months = ['Jan','Feb','Mar','Apr','May','Jun',
                      'Jul','Aug','Sep','Oct','Nov','Dec'];
      final hour   = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final ampm   = dt.hour >= 12 ? 'PM' : 'AM';
      return '${months[dt.month - 1]} ${dt.day}, $hour:$minute $ampm';
    } catch (_) {
      return '$date $time'.trim();
    }
  }
}