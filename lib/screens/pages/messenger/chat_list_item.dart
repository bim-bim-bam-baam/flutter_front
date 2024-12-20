import 'package:flutter/material.dart';
import 'chat_tile.dart'; // Импортируем виджет, который будет использоваться для отображения чатов

class ChatListItem extends StatelessWidget {
  final Map<String, dynamic> chat;
  final String state;
  final token;

  const ChatListItem({super.key, required this.chat, required this.state, required this.token});

  @override
  Widget build(BuildContext context) {
    return ChatTile(
      chat: chat,
      state: state,
      token: token,
    );
  }
}
