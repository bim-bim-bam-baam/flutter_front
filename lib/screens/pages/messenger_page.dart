import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'messenger/chat_list_item.dart'; // Импортируем виджет для отрисовки элементов чатов

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});
  

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;
  String state = "active"; // Стейт по умолчанию
  String gtoken = "";

  // Маппинг стейтов на более понятные названия
  final Map<String, String> stateLabels = {
    "active": "Chats",
    "pending-requests": "Incoming",
    "sent-requests": "Outcoming",
  };

  final List<String> states = ["active", "pending-requests", "sent-requests"]; // Список доступных стейтов
  String _selectedState = "active"; // Переменная для выбранного стейта

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is not available');
      }

      gtoken = token;

      final chatResponse = await http.get(
        Uri.parse('$baseUrl/chat/$state'), // Используем выбранный стейт в URL
        headers: {'Authorization': 'Bearer $token'},
      );

      if (chatResponse.statusCode != 200) {
        throw Exception('Failed to fetch chats');
      }

      final List<dynamic> chatData = json.decode(chatResponse.body);

      final List<Map<String, dynamic>> loadedChats = [];
      for (var chat in chatData) {
        final userId = chat['toUserId'];
        final userResponse = await http.get(
          Uri.parse('$baseUrl/user/$userId'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (userResponse.statusCode != 200) {
          throw Exception('Failed to fetch user info');
        }

        final userData = json.decode(userResponse.body);
        loadedChats.add({
          'id': chat['id'],
          'username': userData['username'],
          'avatar': userData['avatar'],
        });
      }

      setState(() {
        chats = loadedChats;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown для выбора стейта с отображением более понятных значений
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF64FFDA)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(stateLabels[state]!),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedState = value;
                    isLoading = true; // При изменении стейта снова загружаем чаты
                    state = value;  // Обновляем переменную state
                    chats.clear(); // Очищаем старые чаты
                  });
                  await _fetchChats(); // Загружаем чаты для нового стейта
                }
              },
            ),
            const SizedBox(height: 20),

            // Вывод списка чатов
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF64FFDA)),
                      ),
                    )
                  : chats.isEmpty
                      ? const Center(
                          child: Text(
                            'No active chats',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return ChatListItem(
                              chat: chat,
                              state: _selectedState,
                              token: gtoken, 
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
