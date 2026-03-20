// ─────────────────────────────────────────────
//  messages_screen.dart  —  ArtistMatch
//  Polished DM inbox UI (dummy data)
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'chat_screen.dart';

// ── Dummy data ───────────────────────────────────────────────────────────────

class _Contact {
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool isMe;
  final int unread;
  final bool isVerified;

  const _Contact({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.isMe = false,
    this.unread = 0,
    this.isVerified = false,
  });
}

final _dummyChats = [
  _Contact(
    name: 'Helena Hills',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    lastMessage: 'Lets meet up to do the vocals 🎤',
    time: '2m',
    isOnline: true,
    unread: 3,
    isVerified: true,
  ),
  _Contact(
    name: 'Teezy',
    avatar: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200',
    lastMessage: 'Bro that new beat is FIRE 🔥',
    time: '11m',
    isOnline: true,
    unread: 1,
    isVerified: true,
  ),
  _Contact(
    name: 'Marco V',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    lastMessage: 'You: I can do Friday, what time?',
    time: '1h',
    isOnline: false,
    isMe: true,
    unread: 0,
    isVerified: false,
  ),
  _Contact(
    name: 'DJ Pulse',
    avatar: 'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=200',
    lastMessage: 'Check out my new set when you get a chance',
    time: '3h',
    isOnline: true,
    unread: 0,
    isVerified: false,
  ),
  _Contact(
    name: 'Aria Nova',
    avatar: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200',
    lastMessage: 'You: Sent you the stems 📎',
    time: 'Yesterday',
    isOnline: false,
    isMe: true,
    unread: 0,
    isVerified: true,
  ),
  _Contact(
    name: 'Bass Brothers',
    avatar: 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=200',
    lastMessage: 'The gig at Industry was insane last night',
    time: 'Yesterday',
    isOnline: false,
    unread: 0,
    isVerified: false,
  ),
  _Contact(
    name: 'Zara Bloom',
    avatar: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=200',
    lastMessage: 'You: Can we reschedule the session?',
    time: 'Mon',
    isOnline: false,
    isMe: true,
    unread: 0,
    isVerified: false,
  ),
];

// ── Colours ───────────────────────────────────────────────────────────────────

const _bg      = Color(0xFF0A0A0A);
const _surface = Color(0xFF141414);
const _card    = Color(0xFF1C1C1E);
const _border  = Color(0xFF252525);
const _blue    = Color(0xFF0094FF);
const _blueDim = Color(0xFF00305A);
const _pri     = Color(0xFFF5F5F5);
const _sec     = Color(0xFF888888);
const _muted   = Color(0xFF3A3A3A);
const _green   = Color(0xFF30D158);

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<_Contact> get _filtered => _dummyChats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _blueDim,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _blue.withOpacity(0.4)),
                ),
                child: const Text(
                  '4 unread',
                  style: TextStyle(
                      color: _blue, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  // ── Section label ────────────────────────────────────────────────────────────

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
              letterSpacing: 0.6,
            ),
          ),
          const Spacer(),
          Text(
            '${_dummyChats.length}',
            style: const TextStyle(
                color: _muted, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ── Chat list ─────────────────────────────────────────────────────────────────

  Widget _buildChatList() {
    final chats = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: chats.length,
      itemBuilder: (context, i) => _AnimatedTile(
        index: i,
        child: _ChatTile(
          contact: chats[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                chatId: 'demo_${chats[i].name.replaceAll(' ', '_')}',
                otherUserName: chats[i].name,
                otherUserAvatar: chats[i].avatar,
                otherUserId: 'uid_${chats[i].name}',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Chat tile
// ─────────────────────────────────────────────

class _ChatTile extends StatelessWidget {
  final _Contact contact;
  final VoidCallback onTap;
  const _ChatTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = contact.unread > 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasUnread ? _blue.withOpacity(0.6) : _border,
                      width: hasUnread ? 2 : 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      contact.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: _card,
                          child: const Icon(Icons.person, color: _sec)),
                    ),
                  ),
                ),
                if (contact.isOnline)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: _green,
                        shape: BoxShape.circle,
                        border: Border.all(color: _bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                contact.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _pri,
                                  fontSize: 15,
                                  fontWeight: hasUnread
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            if (contact.isVerified) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                    color: _blue, shape: BoxShape.circle),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 9),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        contact.time,
                        style: TextStyle(
                          color: hasUnread ? _blue : _sec,
                          fontSize: 11,
                          fontWeight:
                          hasUnread ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasUnread
                                ? _pri.withOpacity(0.75)
                                : _sec,
                            fontSize: 13,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          constraints:
                          const BoxConstraints(minWidth: 20),
                          height: 20,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: _blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${contact.unread}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
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

// ─────────────────────────────────────────────
//  Staggered slide-in animation per tile
// ─────────────────────────────────────────────

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
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

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
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}