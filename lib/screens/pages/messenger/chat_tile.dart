import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:http/http.dart' as http;
import '../chat_page.dart';

class ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final String state;
  final token;

  const ChatTile({super.key, required this.chat, required this.state, required this.token});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case 'active':
        return _buildActiveChat(context);
      case 'pending-requests':
        return _buildPendingRequestChat(context);
      case 'sent-requests':
        return _buildSentRequestChat(context);
      default:
        return _buildActiveChat(context);
    }
  }

Widget _buildActiveChat(BuildContext context) {
  // Локальное состояние
  bool isDeclined = false; // Состояние: отклонён ли чат
  Color backgroundColor = const Color(0xFF1E1E1E); // Изначальный цвет фона

  return StatefulBuilder(
    builder: (context, setState) => Container(
      decoration: BoxDecoration(
        color: isDeclined ? Colors.red : backgroundColor, // Меняем цвет при отклонении
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64FFDA).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat['avatar']),
          backgroundColor: const Color(0xFF64FFDA),
        ),
        title: Text(
          chat['username'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          'Tap to open chat',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: isDeclined
            ? null // Если чат отклонён, кнопка не отображается
            : IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  // Показываем диалог подтверждения
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1E1E1E),
                        title: const Text(
                          'Delete this chat?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white70),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрыть диалог
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop(); // Закрыть диалог
                              try {
                                final response = await http.post(
                                  Uri.parse('$baseUrl/chat/${chat['id']}/decline'),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                );
                                if (response.statusCode == 200) {
                                  // Успешно отклонили чат
                                  setState(() {
                                    isDeclined = true; // Устанавливаем статус отклонения
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Chat declined')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to decline chat: ${response.body}')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
        onTap: () {
          if (!isDeclined) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(chatName: chat['username'], chatId: chat['id'], avatar: chat['avatar']),
              ),
            );
          }
        },
      ),
    ),
  );
}


Widget _buildPendingRequestChat(BuildContext context) {
  // Добавим локальное состояние
  bool actionCompleted = false; // Состояние: завершено ли действие
  Color backgroundColor = Colors.orange[700]!; // Текущий цвет фона

  return StatefulBuilder(
    builder: (context, setState) => Container(
      decoration: BoxDecoration(
        color: actionCompleted ? backgroundColor : Colors.orange[700], // Меняем цвет в зависимости от действия
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat['avatar']),
          backgroundColor: const Color(0xFF64FFDA),
        ),
        title: Text(
          chat['username'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          'Incoming request',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: actionCompleted
            ? null // Если действие выполнено, кнопки не отображаются
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Зеленая кнопка для принятия
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      try {
                        final response = await http.post(
                          Uri.parse('$baseUrl/chat/${chat['id']}/accept'),
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                        );
                        if (response.statusCode == 200) {
                          setState(() {
                            actionCompleted = true; // Действие завершено
                            backgroundColor = Colors.green; // Цвет фона — зелёный
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request accepted')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to accept request: ${response.body}')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                  ),
                  // Красная кнопка для отклонения
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () async {
                      try {
                        final response = await http.post(
                          Uri.parse('$baseUrl/chat/${chat['id']}/decline'),
                          headers: {
                            'Authorization': 'Bearer $token',
                          },
                        );
                        if (response.statusCode == 200) {
                          setState(() {
                            actionCompleted = true; // Действие завершено
                            backgroundColor = Colors.red; // Цвет фона — красный
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request declined')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to decline request: ${response.body}')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
        onTap: () {
          // Переход в чат (если нужно)
        },
      ),
    ),
  );
}



  Widget _buildSentRequestChat(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat['avatar']),
          backgroundColor: const Color(0xFF64FFDA),
        ),
        title: Text(
          chat['username'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: const Text(
          'Outgoing request',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        onTap: () {
          // Переход в чат (если нужно)
        },
      ),
    );
  }
}
