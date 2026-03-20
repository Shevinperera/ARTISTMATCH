
import 'package:flutter/material.dart';


enum _ChatType { date, incoming, outgoing, outgoingFile }

class _ChatItem {
  final _ChatType type;
  final String text;
  _ChatItem._(this.type, this.text);
  factory _ChatItem.date(String t)         => _ChatItem._(_ChatType.date, t);
  factory _ChatItem.incoming(String t)     => _ChatItem._(_ChatType.incoming, t);
  factory _ChatItem.outgoing(String t)     => _ChatItem._(_ChatType.outgoing, t);
  factory _ChatItem.outgoingFile(String t) => _ChatItem._(_ChatType.outgoingFile, t);
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserName;
  final String otherUserAvatar;
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _showEmoji   = false;

  final List<_ChatItem> _messages = [
    _ChatItem.outgoing("Hey check this beat out!"),
    _ChatItem.outgoingFile("timeflies.mp3"),
    _ChatItem.date("Nov 30, 2025, 9:41 AM"),
    _ChatItem.incoming("Oh?"),
    _ChatItem.incoming("Thats firee! 🔥"),
    _ChatItem.incoming("Lets meet up to do the vocals."),
    _ChatItem.incoming("Next week sound good?"),
    _ChatItem.outgoing("Great!"),
    _ChatItem.outgoing("How about Tuesday?"),
    _ChatItem.incoming("Hmmm"),
    _ChatItem.incoming("I think I can do Tuesday."),
    _ChatItem.incoming("Will let you know within the day!\nAlso let me know the BPM."),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatItem.outgoing(text));
      _controller.clear();
      _showEmoji = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _InputBar(
              controller: _controller,
              onSend: _send,
              onEmoji: () {
                FocusScope.of(context).unfocus();
                setState(() => _showEmoji = !_showEmoji);
              },
              onImage: () {},
              onFocusText: () => setState(() => _showEmoji = false),
            ),
            if (_showEmoji)
              _EmojiPanel(onPick: (e) {
                setState(() {
                  _controller.text = _controller.text + e;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                });
              }),
          ],
        ),
      ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0094FF), width: 1.5),
            ),
            child: ClipOval(
              child: widget.otherUserAvatar.isNotEmpty
                  ? Image.network(
                widget.otherUserAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, size: 20),
              )
                  : const Icon(Icons.person, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const Text(
                  'Active now',
                  style: TextStyle(fontSize: 11, color: Color(0xFF30D158)),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Message list ─────────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, i) {
        final item = _messages[i];

        // Date separator
        if (item.type == _ChatType.date) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                item.text,
                style: const TextStyle(color: Color(0xFFDADADA), fontSize: 12),
              ),
            ),
          );
        }

        final isMe = item.type == _ChatType.outgoing ||
            item.type == _ChatType.outgoingFile;

        // Grouping
        bool samePrev = false, sameNext = false;
        if (i > 0) {
          final prev = _messages[i - 1];
          samePrev = (isMe &&
              (prev.type == _ChatType.outgoing ||
                  prev.type == _ChatType.outgoingFile)) ||
              (!isMe && prev.type == _ChatType.incoming);
        }
        if (i < _messages.length - 1) {
          final next = _messages[i + 1];
          sameNext = (isMe &&
              (next.type == _ChatType.outgoing ||
                  next.type == _ChatType.outgoingFile)) ||
              (!isMe && next.type == _ChatType.incoming);
        }

        _BubblePos pos;
        if (!samePrev && sameNext)      pos = _BubblePos.top;
        else if (samePrev && sameNext)  pos = _BubblePos.middle;
        else if (samePrev && !sameNext) pos = _BubblePos.bottom;
        else                            pos = _BubblePos.single;

        final bubble = _ChatBubble(
          isMe: isMe,
          position: pos,
          child: item.type == _ChatType.outgoingFile
              ? _FileBubble(filename: item.text)
              : Text(
            item.text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

        if (isMe) {
          return Padding(
            padding: EdgeInsets.only(bottom: sameNext ? 2 : 8),
            child: Align(alignment: Alignment.centerRight, child: bubble),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: sameNext ? 2 : 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (pos == _BubblePos.bottom || pos == _BubblePos.single)
                Container(
                  width: 26, height: 26,
                  margin: const EdgeInsets.only(right: 6),
                  child: ClipOval(
                    child: widget.otherUserAvatar.isNotEmpty
                        ? Image.network(widget.otherUserAvatar,
                        fit: BoxFit.cover)
                        : const Icon(Icons.person, size: 16),
                  ),
                )
              else
                const SizedBox(width: 32),
              Flexible(child: bubble),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Widgets
// ─────────────────────────────────────────────

enum _BubblePos { single, top, middle, bottom }

class _ChatBubble extends StatelessWidget {
  final bool isMe;
  final _BubblePos position;
  final Widget child;
  const _ChatBubble(
      {required this.isMe, required this.position, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xFF0094FF) : const Color(0xFFDFDFDF);
    final BorderRadius radius;
    if (isMe) {
      radius = BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: Radius.circular(position == _BubblePos.middle ? 4 : 18),
        bottomLeft: const Radius.circular(18),
        bottomRight: Radius.circular(
            (position == _BubblePos.top || position == _BubblePos.middle)
                ? 4 : 18),
      );
    } else {
      radius = BorderRadius.only(
        topLeft: Radius.circular(position == _BubblePos.middle ? 4 : 18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(
            (position == _BubblePos.top || position == _BubblePos.middle)
                ? 4 : 18),
        bottomRight: const Radius.circular(18),
      );
    }
    return Container(
      constraints:
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: radius),
      child: child,
    );
  }
}

class _FileBubble extends StatelessWidget {
  final String filename;
  const _FileBubble({required this.filename});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.insert_drive_file,
            color: Colors.white, size: 16),
      ),
      const SizedBox(width: 8),
      Text(filename,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14)),
    ],
  );
}

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
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDFDFDF)),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: controller,
            style:
            const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Message...',
              hintStyle: TextStyle(
                  color: Color(0xFF888888), fontSize: 14),
              border: InputBorder.none,
              isDense: true,
            ),
            onTap: onFocusText,
            onSubmitted: (_) => onSend(),
          ),
        ),
        _Ic(icon: Icons.emoji_emotions_outlined, onTap: onEmoji),
        const SizedBox(width: 14),
        _Ic(icon: Icons.image_outlined, onTap: onImage),
        const SizedBox(width: 14),
        GestureDetector(
          onTap: onSend,
          child: Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF0094FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send,
                color: Colors.white, size: 16),
          ),
        ),
      ]),
    ),
  );
}

class _Ic extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Ic({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Icon(icon, size: 22, color: Colors.white),
  );
}

class _EmojiPanel extends StatelessWidget {
  final void Function(String) onPick;
  const _EmojiPanel({required this.onPick});

  static const _emojis = [
    "😀","😅","😂","🥲","😍","😎","🤩","😭",
    "👍","🙏","🔥","🎵","🎤","🎧","💯","✅",
    "😡","🤔","😴","🥳","💙","❤️","⭐","📎",
  ];

  @override
  Widget build(BuildContext context) => Container(
    height: 180,
    color: Colors.black,
    padding: const EdgeInsets.all(12),
    child: GridView.builder(
      itemCount: _emojis.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8),
      itemBuilder: (_, i) => InkWell(
        onTap: () => onPick(_emojis[i]),
        child: Center(
            child: Text(_emojis[i],
                style: const TextStyle(fontSize: 22))),
      ),
    ),
  );
}