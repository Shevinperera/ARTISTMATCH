import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatItem> _items = [];

  // Mic (speech-to-text)
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Emoji panel
  bool _showEmojiPanel = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------- Storage ----------
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_history');

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _items
          ..clear()
          ..addAll(decoded.map((e) => _ChatItem.fromJson(e)).toList());
      });
    } else {
      // Seed demo messages like your Figma
      setState(() {
        _items.addAll([
          _ChatItem.outgoingText("Hey check this beat out!"),
          _ChatItem.outgoingFile("timeflies.mp3"),
          _ChatItem.date("Nov 30, 2025, 9:41 AM"),
          _ChatItem.incomingText("Oh?"),
          _ChatItem.incomingText("Thats firee!"),
          _ChatItem.incomingText("Lets meet up to do the vocals."),
          _ChatItem.incomingText("Next week sound good?"),
          _ChatItem.outgoingText("Great!"),
          _ChatItem.outgoingText("How about Tuesday?"),
          _ChatItem.incomingText("Hmmm"),
          _ChatItem.incomingText("I think I can do Tuesday."),
          _ChatItem.incomingText(
            "Will let you know within the day!\nAlso let me know the BPM of the track.",
          ),
        ]);
      });
      await _saveMessages();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString('chat_history', encoded);
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // ---------- Send ----------
  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(_ChatItem.outgoingText(text));
      _controller.clear();
    });

    _saveMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ---------- Emoji ----------
  void _toggleEmoji() {
    FocusScope.of(context).unfocus();
    setState(() => _showEmojiPanel = !_showEmojiPanel);
  }

  void _addEmoji(String emoji) {
    _controller.text = _controller.text + emoji;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  // ---------- Mic ----------
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: const [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _HeaderTitle(
                name: "Helena Hills",
                status: "Active 11m ago",
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

                  if (item.type == _ChatType.date) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          item.text!,
                          style: const TextStyle(
                            color: Color(0xFFDADADA),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }

                  final isMe = item.type == _ChatType.outgoingText ||
                      item.type == _ChatType.outgoingFile;

                  if (!isMe) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200",
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: _ChatBubble(
                              isMe: false,
                              position: _bubblePosition(index, false),
                              child: Text(
                                item.text!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  height: 1.40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ChatBubble(
                        isMe: true,
                        position: _bubblePosition(index, true),
                        child: item.type == _ChatType.outgoingFile
                            ? _FileBubble(filename: item.text!)
                            : Text(
                                item.text!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.40,
                                  fontWeight: FontWeight.w500,
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
              isListening: _isListening,
              onSend: _send,
              onMic: _toggleMic,
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

  _BubblePos _bubblePosition(int index, bool isMe) {
    bool samePrev = false;
    bool sameNext = false;

    if (index - 1 >= 0) {
      final prev = _items[index - 1];
      samePrev = prev.type == _items[index].type ||
          (isMe &&
              (prev.type == _ChatType.outgoingText ||
                  prev.type == _ChatType.outgoingFile) &&
              (_items[index].type == _ChatType.outgoingText ||
                  _items[index].type == _ChatType.outgoingFile)) ||
          (!isMe &&
              prev.type == _ChatType.incomingText &&
              _items[index].type == _ChatType.incomingText);
    }

    if (index + 1 < _items.length) {
      final next = _items[index + 1];
      sameNext = next.type == _items[index].type ||
          (isMe &&
              (next.type == _ChatType.outgoingText ||
                  next.type == _ChatType.outgoingFile) &&
              (_items[index].type == _ChatType.outgoingText ||
                  _items[index].type == _ChatType.outgoingFile)) ||
          (!isMe &&
              next.type == _ChatType.incomingText &&
              _items[index].type == _ChatType.incomingText);
    }

    if (!samePrev && sameNext) return _BubblePos.top;
    if (samePrev && sameNext) return _BubblePos.middle;
    if (samePrev && !sameNext) return _BubblePos.bottom;
    return _BubblePos.single;
  }
}

// ---------- Header ----------
class _HeaderTitle extends StatelessWidget {
  final String name;
  final String status;

  const _HeaderTitle({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          status,
          style: const TextStyle(fontSize: 12, color: Color(0xFF828282)),
        ),
      ],
    );
  }
}

// ---------- Bubble grouping ----------
enum _BubblePos { single, top, middle, bottom }

// ---------- Chat bubble ----------
class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final _BubblePos position;
  final Widget child;

  const _ChatBubble({
    required this.isMe,
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xFF0094FF) : const Color(0xFFDFDFDF);

    BorderRadius radius;
    if (isMe) {
      radius = BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: Radius.circular(position == _BubblePos.middle ? 4 : 18),
        bottomLeft: const Radius.circular(18),
        bottomRight: Radius.circular(
          (position == _BubblePos.top || position == _BubblePos.middle) ? 4 : 18,
        ),
      );
    } else {
      radius = BorderRadius.only(
        topLeft: Radius.circular(position == _BubblePos.middle ? 4 : 18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(
          (position == _BubblePos.top || position == _BubblePos.middle) ? 4 : 18,
        ),
        bottomRight: const Radius.circular(18),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}

// ---------- File bubble ----------
class _FileBubble extends StatelessWidget {
  final String filename;

  const _FileBubble({required this.filename});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.insert_drive_file, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          filename,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.40,
          ),
        ),
      ],
    );
  }
}

// ---------- Input bar ----------
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final VoidCallback onEmoji;
  final VoidCallback onImage;
  final VoidCallback onFocusText;
  final bool isListening;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.onEmoji,
    required this.onImage,
    required this.onFocusText,
    required this.isListening,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.40,
                    ),
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
                _Icon24(icon: isListening ? Icons.mic : Icons.mic_none, onTap: onMic),
                const SizedBox(width: 16),
                _Icon24(icon: Icons.emoji_emotions_outlined, onTap: onEmoji),
                const SizedBox(width: 16),
                _Icon24(icon: Icons.image_outlined, onTap: onImage),
                const SizedBox(width: 16),
                _Icon24(icon: Icons.send, onTap: onSend),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}

class _Icon24 extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _Icon24({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}

// ---------- Emoji panel ----------
class _EmojiPanel extends StatelessWidget {
  final void Function(String) onPick;

  const _EmojiPanel({required this.onPick});

  static const _emojis = [
    "😀","😅","😂","🥲","😍","😎","🤩","😭",
    "👍","🙏","🔥","🎵","🎤","🎧","💯","✅",
    "😡","🤔","😴","🥳","💙","❤️","⭐","📎",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: _emojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, i) {
          final e = _emojis[i];
          return InkWell(
            onTap: () => onPick(e),
            child: Center(
              child: Text(e, style: const TextStyle(fontSize: 22)),
            ),
          );
        },
      ),
    );
  }
}

// ---------- Model ----------
enum _ChatType { date, incomingText, outgoingText, outgoingFile }

class _ChatItem {
  final _ChatType type;
  final String? text;

  _ChatItem._(this.type, this.text);

  factory _ChatItem.date(String t) => _ChatItem._(_ChatType.date, t);
  factory _ChatItem.incomingText(String t) => _ChatItem._(_ChatType.incomingText, t);
  factory _ChatItem.outgoingText(String t) => _ChatItem._(_ChatType.outgoingText, t);
  factory _ChatItem.outgoingFile(String filename) =>
      _ChatItem._(_ChatType.outgoingFile, filename);

  Map<String, dynamic> toJson() => {'type': type.index, 'text': text};

  factory _ChatItem.fromJson(Map<String, dynamic> json) =>
      _ChatItem._(_ChatType.values[json['type']], json['text']);
}