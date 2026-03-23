import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationsPage extends StatefulWidget {
  final int userId;
  const NotificationsPage({super.key, required this.userId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

  // Notification types
  static const String typeCollab = 'collab';
  static const String typeFollow = 'follow';
  static const String typeGeneral = 'general';

  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  late int _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _fetchNotifications();
  }
  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://artistmatch-backend-production.up.railway.app/api/notifications/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _notifications = data.map((n) => {
            'type': n['type'],
            'name': n['sender_name'],
            'message': n['message'],
            'time': n['created_at'],
            'image': n['sender_avatar'] ?? 'https://picsum.photos/55/55?random=1',
            'accepted': null,
            'followedBack': false,
          }).toList();
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }


//   final List<Map<String, dynamic>> _notifications = [
//     {
//       'type': typeCollab,
//       'name': 'Dion Fernando',
//       'message': 'Sent you a Collaboration Request',
//       'time': '9:41 AM',
//       'image': 'https://picsum.photos/55/55?random=1',
//       'accepted': null, // null = pending, true = accepted, false = declined
//     },
//     {
//       'type': typeFollow,
//       'name': 'Shevin Perera',
//       'message': 'Followed you',
//       'time': '6:09 AM',
//       'image': 'https://picsum.photos/55/55?random=2',
//       'followedBack': false,
//     },
//     {
//       'type': typeGeneral,
//       'name': 'Shevin Perera',
//       'message': 'Visited your Spotify',
//       'time': '6:07 AM',
//       'image': 'https://picsum.photos/55/55?random=2',
//     },
//     {
//       'type': typeGeneral,
//       'name': 'Shevin Perera',
//       'message': 'Liked your Post',
//       'time': '6:07 AM',
//       'image': 'https://picsum.photos/55/55?random=2',
//     },
//   ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           // Header
  //           Container(
  //             width: double.infinity,
  //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //             decoration: const BoxDecoration(
  //               color: Colors.black,
  //               border: Border(
  //                 bottom: BorderSide(width: 0.5, color: Color(0xFFE6E6E6)),
  //               ),
  //             ),
  //             child: Row(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => Navigator.pop(context),
  //                   child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 const Text(
  //                   'Notifications',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20,
  //                     fontFamily: 'Inter',
  //                     fontWeight: FontWeight.w600,
  //                     height: 1.40,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF0088FF)),
      )
          : SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Color(0xFFE6E6E6)),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.40,
                    ),
                  ),
                ],
              ),
            ),

            // Notification list
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                children: [
                  ..._notifications.asMap().entries.map((entry) {
                    final index = entry.key;
                    final notif = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildNotificationCard(notif, index),
                    );
                  }),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'No Older Notifications',
                      style: TextStyle(
                        color: Color(0xFF727272),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif, int index) {
    final bool hasActions = notif['type'] == typeCollab ||
        notif['type'] == typeFollow;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.07),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 40,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + name + message + time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 55,
                height: 55,
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                child: Image.network(
                  notif['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF595959),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name + message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      notif['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.21,
                        letterSpacing: -0.23,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['message'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                        letterSpacing: -0.23,
                      ),
                    ),
                  ],
                ),
              ),
              // Time
              Text(
                notif['time'],
                style: const TextStyle(
                  color: Color(0xFF4C4C4C),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Action buttons
          if (hasActions) ...[
            const SizedBox(height: 12),
            _buildActionButtons(notif, index),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> notif, int index) {
    if (notif['type'] == typeCollab) {
      // Already responded
      if (notif['accepted'] != null) {
        return Center(
          child: Text(
            notif['accepted'] ? 'Request Accepted' : 'Request Declined',
            style: TextStyle(
              color: notif['accepted']
                  ? const Color(0xFF0088FF)
                  : const Color(0xFFFF383C),
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      // Pending
      return Row(
        children: [
          Expanded(
            child: _actionButton(
              label: 'Accept',
              color: const Color(0xFF0088FF),
              onTap: () => setState(() => _notifications[index]['accepted'] = true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionButton(
              label: 'Decline',
              color: const Color(0xFFFF383C),
              onTap: () => setState(() => _notifications[index]['accepted'] = false),
            ),
          ),
        ],
      );
    }

    if (notif['type'] == typeFollow) {
      if (notif['followedBack'] == true) {
        return const Center(
          child: Text(
            'Following',
            style: TextStyle(
              color: Color(0xFF0088FF),
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      return _actionButton(
        label: 'Follow Back',
        color: const Color(0xFF0088FF),
        onTap: () => setState(() => _notifications[index]['followedBack'] = true),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.23,
            ),
          ),
        ),
      ),
    );
  }
}