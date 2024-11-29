import 'package:flutter/material.dart';
import 'chat_page.dart';

class MessengerPage extends StatelessWidget {
  const MessengerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {'name': 'Alice', 'lastMessage': 'Hi! How are you?'},
      {'name': 'Bob', 'lastMessage': 'Let’s catch up tomorrow!'},
      {'name': 'Charlie', 'lastMessage': 'See you at the event!'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Темный фон
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E), // Темно-серый фон карточки
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64FFDA).withOpacity(0.2), // Зеленая тень
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF64FFDA), // Мягкий зеленый
                child: Text(
                  chat['name']![0], // Первая буква имени
                  style: const TextStyle(color: Colors.black), // Черный текст
                ),
              ),
              title: Text(
                chat['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Белый текст
                ),
              ),
              subtitle: Text(
                chat['lastMessage']!,
                style: const TextStyle(
                  color: Colors.white70, // Мягкий белый текст
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(chatName: chat['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
