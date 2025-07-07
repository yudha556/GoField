import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/chatService.dart';
import 'package:gofield/core/models/chat_model.dart';
import 'package:go_router/go_router.dart';


class OwnerToUserChatPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final String ownerId;
  final String lapanganId;

  const OwnerToUserChatPage({
    Key? key,
    required this.contactName,
    required this.contactAvatar,
    required this.ownerId,
    required this.lapanganId,
  }) : super(key: key);

  @override
  _OwnerToUserChatPageState createState() => _OwnerToUserChatPageState();
}

class _OwnerToUserChatPageState extends State<OwnerToUserChatPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late String currentUserId;
  String? _percakapanId; // Ubah menjadi nullable
  Stream<List<ChatMessage>>? _chatStream; // Ubah menjadi nullable

  late AnimationController _typingAnimationController;
  bool isTyping = false;
  bool isLoading = true; // Tambahkan loading state

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // Handle case when user is not authenticated
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
          Navigator.pop(context);
        }
        return;
      }

      currentUserId = user.id;

      final percakapanId = await ChatService().getOrCreatePercakapan(
        currentUserId,
        widget.ownerId,
      );

      if (mounted) {
        setState(() {
          _percakapanId = percakapanId;
          _chatStream = ChatService().listenToMessages(percakapanId);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing chat: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final isi = _messageController.text.trim();
    if (isi.isEmpty || _percakapanId == null) return;

    try {
      await ChatService().sendMessage(
        percakapanId: _percakapanId!,
        pengirimId: currentUserId,
        isi: isi,
      );

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  widget.contactAvatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C851),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.contactName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    // Tampilkan loading jika masih inisialisasi
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Tampilkan error jika stream null
    if (_chatStream == null) {
      return const Center(
        child: Text('Failed to load messages'),
      );
    }

    return StreamBuilder<List<ChatMessage>>(
      stream: _chatStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading messages: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    _initializeChat();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final messages = snapshot.data ?? [];
        
        if (messages.isEmpty) {
          return const Center(
            child: Text(
              'No messages yet\nSend a message to start conversation',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg.pengirimId == currentUserId;

            return _buildMessageBubble(msg.isi, isMe, msg.timestamp);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4285F4),
              child: Text(
                widget.contactAvatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF4285F4) : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: null,
                enabled: !isLoading && _percakapanId != null,
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4285F4).withOpacity(
                    isLoading || _percakapanId == null ? 0.5 : 1.0,
                  ),
                  const Color(0xFF1976D2).withOpacity(
                    isLoading || _percakapanId == null ? 0.5 : 1.0,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4285F4).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: (isLoading || _percakapanId == null) ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (msgDay == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}