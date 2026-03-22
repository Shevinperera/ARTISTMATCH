import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'socket_service.dart';
import 'chat_screen.dart';

// ── Colours ─────────────────────────────────
const _bg      = Color(0xFF0A0A0A);
const _card    = Color(0xFF1C1C1E);
const _border  = Color(0xFF252525);
const _blue    = Color(0xFF0094FF);
const _blueDim = Color(0xFF00305A);
const _pri     = Color(0xFFF5F5F5);
const _sec     = Color(0xFF888888);
const _muted   = Color(0xFF3A3A3A);

// ─────────────────────────────────────────────

class ConversationsScreen extends StatefulWidget {
  final int currentUserId;
  const ConversationsScreen({super.key, required this.currentUserId});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}


class _ConversationsScreenState extends State<ConversationsScreen>
    with TickerProviderStateMixin {
  List _conversations = [];
  bool _loading = true;
  late final AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _loadConversations();

    // Real-time updates
    SocketService.socket?.on("receiveMessage", (_) => _loadConversations());
    SocketService.socket?.on("conversationUpdated", (_) => _loadConversations());
  }

  // ── LOAD CONVERSATIONS FROM API ─────────────────────────────
  Future<void> _loadConversations() async {
    print('Loading conversations for userId: ${widget.currentUserId}');
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/messages/conversations/${widget.currentUserId}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _conversations = data.map((c) => {
            ...c,
            'other_user_id': int.tryParse(c['other_user_id'].toString()) ?? 0,
            'unread_count': int.tryParse(c['unread_count'].toString()) ?? 0,
          }).toList();
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        print("Failed to load conversations: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _loading = false);
      print("Error loading conversations: $e");
    }
  }

  int get _totalUnread {
    return _conversations.fold(
      0,
          (sum, c) => sum + ((c['unread_count'] ?? 0) as int),
    );
  }

  @override
  void dispose() {
    SocketService.socket?.off("receiveMessage");
    SocketService.socket?.off("conversationUpdated");
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── MARK CHAT AS READ ─────────────────────────────
  Future<void> _markChatAsRead(int otherUserId) async {
    try {
      await http.put(
        Uri.parse('http://10.0.2.2:5000/api/messages/read/$otherUserId/${widget.currentUserId}'),
      );
    } catch (e) {
      print("Error marking as read: $e");
    }
  }

  // ── BUILD UI ─────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : FadeTransition(
          opacity: _fadeCtrl,
          child: Column(
            children: [
              _buildHeader(),
              _buildSectionLabel(),
              Expanded(child: _buildChatList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  color: _pri,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _blueDim,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_totalUnread unread',
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          const Text(
            'All Chats',
            style: TextStyle(
              color: _sec,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${_conversations.length}',
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, i) {
        final convo = _conversations[i];
        final unread = convo['unread_count'] ?? 0;

        return _AnimatedTile(
          index: i,
          child: _ChatTile(
            name: convo['other_user_name'] ?? 'User ${convo['other_user_id']}',
            message: convo['message'] ?? '',
            time: '',
            avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200",
            unread: unread,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    currentUserId: widget.currentUserId,
                    receiverId: convo['other_user_id'],
                    receiverName: convo['other_user_name'] ?? 'User ${convo['other_user_id']}',
                  ),
                ),
              );
              // ✅ mark chat as read and reload
              await _markChatAsRead(convo['other_user_id']);
              _loadConversations();
            },
          ),
        );
      },
    );
  }
}

// ── CHAT TILE ─────────────────────────────
class _ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatar;
  final int unread;
  final VoidCallback onTap;

  const _ChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unread > 0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(radius: 27, backgroundImage: NetworkImage(avatar)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: _pri,
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: hasUnread ? _blue : _sec,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: hasUnread ? _pri : _sec),
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: _blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$unread",
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── ANIMATION ─────────────────────────────
class _AnimatedTile extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedTile({required this.index, required this.child});

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, 0.05), end: Offset.zero).animate(_fade);

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
  }
}

// ── MODEL ─────────────────────────────
enum _ChatType { date, incomingText, outgoingText, outgoingFile }

class _ChatItem {
  final _ChatType type;
  final String? text;

  _ChatItem._(this.type, this.text);

  factory _ChatItem.date(String t) => _ChatItem._(_ChatType.date, t);
  factory _ChatItem.incomingText(String t) => _ChatItem._(_ChatType.incomingText, t);
  factory _ChatItem.outgoingText(String t) => _ChatItem._(_ChatType.outgoingText, t);
  factory _ChatItem.outgoingFile(String filename) => _ChatItem._(_ChatType.outgoingFile, filename);

  Map<String, dynamic> toJson() => {'type': type.index, 'text': text};

  factory _ChatItem.fromJson(Map<String, dynamic> json) =>
      _ChatItem._(_ChatType.values[json['type']], json['text']);
}