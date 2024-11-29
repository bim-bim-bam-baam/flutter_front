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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                chat['name']![0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat['lastMessage']!),
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
    );
  }
}
