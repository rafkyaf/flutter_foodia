import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'message_screen.dart'; // to reuse ProfileImage

class ChatScreen extends StatefulWidget {
  final Map<String, String> user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  // simple in-memory messages; in a real app this comes from a service
  final List<Map<String, dynamic>> _messages = [
    {'text': "Do you have a time for interviews today?", 'time': '4:30 AM', 'isMe': false},
    {'text': 'Yes, I have.', 'time': '9:30 AM', 'isMe': true},
    {'text': 'Okay, please meet me at Franklin Avenue at 5 pm', 'time': '9:44 AM', 'isMe': false},
    {'text': 'Roger that sir, thank you', 'time': '9:30 AM', 'isMe': true},
    {'text': 'Do you have a time', 'time': '10:44 AM', 'isMe': false},
    {'text': 'Yes', 'time': '9:30 AM', 'isMe': true},
    {'text': 'Okay', 'time': '11:15 AM', 'isMe': false},
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': text.trim(),
        'time': TimeOfDay.now().format(context),
        'isMe': true,
      });
    });
    _controller.clear();

    // scroll to bottom after a short delay to allow build to finish
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user['name'] ?? 'Unknown';
    final image = widget.user['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            ProfileImage(imageUrl: image, name: name, radius: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Online', style: GoogleFonts.poppins(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFEFF7FB), // light-blue chat background
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isMe = m['isMe'] as bool? ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe) const SizedBox(width: 8),
                      if (!isMe)
                        ProfileImage(imageUrl: image, name: name, radius: 14),
                      if (!isMe) const SizedBox(width: 8),

                      // bubble
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.62),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMe ? const Color(0xFF50B6FF) : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: Radius.circular(isMe ? 12 : 6),
                                  bottomRight: Radius.circular(isMe ? 6 : 12),
                                ),
                                boxShadow: isMe
                                    ? null
                                    : [
                                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 6, offset: const Offset(0, 2)),
                                      ],
                              ),
                              child: Text(m['text'] ?? '', style: GoogleFonts.poppins(color: isMe ? Colors.white : Colors.black87)),
                            ),

                            const SizedBox(height: 6),

                            // timestamp aligned
                            Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Text(m['time'] ?? '', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      if (isMe) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input area
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 6, offset: const Offset(0, 2))]),
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.sentiment_satisfied, color: Color(0xFF9FBEDC))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 6, offset: const Offset(0, 2))]),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Type message... ',
                                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                                border: InputBorder.none,
                              ),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _sendMessage(_controller.text),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: const Color(0xFF50B6FF), borderRadius: BorderRadius.circular(20)),
                              child: const Icon(Icons.send, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
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
}

