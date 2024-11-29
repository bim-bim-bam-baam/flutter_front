import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  const ChatPage({super.key, required this.chatName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [
    {'sender': 'Alice', 'text': 'Hi! How are you?'},
    {'sender': 'You', 'text': 'I am good, thanks! And you?'},
    {'sender': 'Alice', 'text': 'Doing great!'}
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'You', 'text': _controller.text.trim()});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Темный фон
      appBar: AppBar(
        title: Text(
          widget.chatName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E), // Темный градиент
        iconTheme: const IconThemeData(color: Color(0xFF64FFDA)), // Иконка "Назад" с мягким зеленым
        elevation: 0,
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'You';
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xFF1F2937) // Темно-зеленый серый для себя
                          : const Color(0xFF2D2D34), // Темно-фиолетовый для других
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isMe
                              ? const Color(0xFF64FFDA).withOpacity(0.1) // Легкий зеленый для себя
                              : const Color(0xFFBB86FC).withOpacity(0.1), // Легкий фиолетовый для других
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['sender']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isMe
                                ? const Color(0xFF64FFDA) // Мягкий зеленый
                                : const Color(0xFFBB86FC), // Мягкий фиолетовый
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['text']!,
                          style: const TextStyle(
                            color: Colors.white70, // Нежный белый
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Поле ввода сообщения
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E), // Темный фон
              border: Border(
                top: BorderSide(color: Color(0xFF64FFDA), width: 1.5),
              ),
            ),
            child: Row(
              children: [
                // Поле ввода
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E), // Темно-серый фон
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Кнопка отправки
                ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64FFDA), // Мягкий зеленый
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}