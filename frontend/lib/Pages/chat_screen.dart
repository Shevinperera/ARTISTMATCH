import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'socket_service.dart';
import 'api_service.dart';

class ChatScreen extends StatefulWidget {
  final int currentUserId;
  final int receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String get _chatKey => 'chat_${widget.currentUserId}_${widget.receiverId}';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatItem> _items = [];

  bool _showEmojiPanel = false;

  @override
  void initState() {
    super.initState();
    debugPrint("💬 currentUserId: ${widget.currentUserId}, receiverId: ${widget.receiverId}, receiverName: ${widget.receiverName}");

    _loadMessages(); // load from SharedPreferences or API

    // Listen for incoming Socket messages
    SocketService.socket?.on("receiveMessage", (data) {
      // ✅ FIX: parse to int to handle both string and int from backend
      final senderId = int.tryParse(data['senderId'].toString()) ?? -1;
      final message = data['message'] ?? '';

      if (senderId == widget.receiverId) {
        setState(() {
          _items.add(_ChatItem.incomingText(message));
        });
        _saveMessages();
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
  }

  @override
  void dispose() {
    SocketService.socket?.off("receiveMessage");
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------- Storage ----------------
  Future<void> _loadMessages() async {
    await _loadApiMessages(); // ✅ always load fresh from API
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_chatKey, encoded);
  }

  Future<void> _loadApiMessages() async {
    try {
      List data = await ApiService.getMessages(widget.currentUserId, widget.receiverId);
      setState(() {
        _items.clear();
        for (var msg in data) {
          if (msg['sender_id'] == widget.currentUserId) {
            _items.add(_ChatItem.outgoingText(msg['message'] ?? ''));
          } else {
            _items.add(_ChatItem.incomingText(msg['message'] ?? ''));
          }
        }
      });
      await _saveMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      print("Failed to load messages from API: $e");
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // ---------------- Send ----------------
  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_ChatItem.outgoingText(text));
      _controller.clear();
    });

    // Save via HTTP POST — this also triggers socket events on the server
    try {
      await http.post(
        Uri.parse('http://10.0.2.2:5000/api/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender_id': widget.currentUserId,
          'receiver_id': widget.receiverId,
          'message': text,
        }),
      );
    } catch (e) {
      debugPrint("Failed to send message: $e");
    }

    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ---------------- Emoji ----------------
  void _toggleEmoji() {
    FocusScope.of(context).unfocus();
    setState(() => _showEmojiPanel = !_showEmojiPanel);
  }

  void _addEmoji(String emoji) {
    _controller.text += emoji;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200"),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HeaderTitle(
                name: widget.receiverName,
                status: "Active",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isMe = item.type == _ChatType.outgoingText || item.type == _ChatType.outgoingFile;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: _ChatBubble(
                        isMe: isMe,
                        position: _BubblePos.single,
                        child: Text(
                          item.text!,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _InputBar(
              controller: _controller,
              onSend: _send,
              onEmoji: _toggleEmoji,
              onImage: () {},
              onFocusText: () => setState(() => _showEmojiPanel = false),
            ),
            if (_showEmojiPanel) _EmojiPanel(onPick: _addEmoji),
          ],
        ),
      ),
    );
  }
}

// ---------------- Header ----------------
class _HeaderTitle extends StatelessWidget {
  final String name;
  final String status;
  const _HeaderTitle({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(status, style: const TextStyle(fontSize: 12, color: Color(0xFF828282))),
      ],
    );
  }
}

// ---------------- Bubble ----------------
enum _BubblePos { single, top, middle, bottom }

class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final _BubblePos position;
  final Widget child;

  const _ChatBubble({required this.isMe, required this.position, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xFF0094FF) : const Color(0xFFDFDFDF);
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
      child: child,
    );
  }
}

// ---------------- Input ----------------
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend, onEmoji, onImage, onFocusText;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onEmoji,
    required this.onImage,
    required this.onFocusText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFDFDFDF)),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.40),
                    decoration: const InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onTap: onFocusText,
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                GestureDetector(onTap: onEmoji, child: const Icon(Icons.emoji_emotions_outlined, size: 24, color: Colors.white)),
                const SizedBox(width: 16),
                GestureDetector(onTap: onImage, child: const Icon(Icons.image_outlined, size: 24, color: Colors.white)),
                const SizedBox(width: 16),
                GestureDetector(onTap: onSend, child: const Icon(Icons.send, size: 24, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Emoji Panel ----------------
class _EmojiPanel extends StatelessWidget {
  final void Function(String) onPick;
  const _EmojiPanel({required this.onPick});

  static const _emojis = ["😀","😅","😂","🥲","😍","😎","🤩","😭","👍","🙏","🔥","🎵","🎤","🎧","💯","✅","😡","🤔","😴","🥳","💙","❤️","⭐","📎"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: _emojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, mainAxisSpacing: 8, crossAxisSpacing: 8),
        itemBuilder: (context, i) => InkWell(onTap: () => onPick(_emojis[i]), child: Center(child: Text(_emojis[i], style: const TextStyle(fontSize: 22)))),
      ),
    );
  }
}

// ---------------- Chat Model ----------------
enum _ChatType { date, incomingText, outgoingText, outgoingFile }

class _ChatItem {
  final _ChatType type;
  final String? text;

  _ChatItem._(this.type, this.text);

  factory _ChatItem.date(String t) => _ChatItem._(_ChatType.date, t);
  factory _ChatItem.incomingText(String t) => _ChatItem._(_ChatType.incomingText, t);
  factory _ChatItem.outgoingText(String t) => _ChatItem._(_ChatType.outgoingText, t);
  factory _ChatItem.outgoingFile(String t) => _ChatItem._(_ChatType.outgoingFile, t);

  Map<String, dynamic> toJson() => {'type': type.index, 'text': text};
  factory _ChatItem.fromJson(Map<String, dynamic> json) => _ChatItem._(_ChatType.values[json['type']], json['text']);
}