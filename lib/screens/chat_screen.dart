import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

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

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _showEmojiPanel = false;

  @override
  void initState() {
    super.initState();

    _loadApiMessages();

    SocketService.socket?.on("receiveMessage", (data) {
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

  // ---------- STORAGE ----------
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_chatKey, encoded);
  }

  Future<void> _loadApiMessages() async {
    try {
      List data = await ApiService.getMessages(
          widget.currentUserId, widget.receiverId);

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
      print("Failed to load messages: $e");
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // ---------- SEND ----------
  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_ChatItem.outgoingText(text));
      _controller.clear();
    });

    SocketService.sendMessage(
      senderId: widget.currentUserId,
      receiverId: widget.receiverId,
      message: text,
    );

    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ---------- EMOJI ----------
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

  // ---------- MIC ----------
  Future<void> _toggleMic() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize();
    if (!available) return;

    setState(() => _isListening = true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
    );
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),

      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(radius: 16),
            const SizedBox(width: 10),
            Expanded(
              child: _HeaderTitle(
                name: widget.receiverName,
                status: "Active",
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isMe =
                    item.type == _ChatType.outgoingText ||
                    item.type == _ChatType.outgoingFile;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: _ChatBubble(
                    isMe: isMe,
                    child: Text(
                      item.text ?? '',
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
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
    );
  }
}

// ---------- HEADER ----------
class _HeaderTitle extends StatelessWidget {
  final String name;
  final String status;

  const _HeaderTitle({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(color: Colors.white)),
        Text(status, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// ---------- BUBBLE ----------
class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final Widget child;

  const _ChatBubble({required this.isMe, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

// ---------- INPUT ----------
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
    return Row(
      children: [
        Expanded(child: TextField(controller: controller)),
        IconButton(icon: const Icon(Icons.emoji_emotions), onPressed: onEmoji),
        IconButton(icon: const Icon(Icons.send), onPressed: onSend),
      ],
    );
  }
}

// ---------- EMOJI ----------
class _EmojiPanel extends StatelessWidget {
  final void Function(String) onPick;

  const _EmojiPanel({required this.onPick});

  static const emojis = ["😀","😂","😍","🔥","🎧","❤️"];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: emojis.map((e) {
        return GestureDetector(
          onTap: () => onPick(e),
          child: Text(e, style: const TextStyle(fontSize: 24)),
        );
      }).toList(),
    );
  }
}

// ---------- MODEL ----------
enum _ChatType { incomingText, outgoingText, outgoingFile }

class _ChatItem {
  final _ChatType type;
  final String? text;

  _ChatItem._(this.type, this.text);

  factory _ChatItem.incomingText(String t) =>
      _ChatItem._(_ChatType.incomingText, t);

  factory _ChatItem.outgoingText(String t) =>
      _ChatItem._(_ChatType.outgoingText, t);

  factory _ChatItem.outgoingFile(String t) =>
      _ChatItem._(_ChatType.outgoingFile, t);

  Map<String, dynamic> toJson() => {'type': type.index, 'text': text};

  factory _ChatItem.fromJson(Map<String, dynamic> json) =>
      _ChatItem._(_ChatType.values[json['type']], json['text']);
}