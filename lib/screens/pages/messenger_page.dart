import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'chat_page.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  _MessengerPageState createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;

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

      final chatResponse = await http.get(
        Uri.parse('http://localhost:8080/api/chat/active'),
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
          Uri.parse('http://localhost:8080/api/user/$userId'),
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
      appBar: AppBar(
        title: const Text('Messenger'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: isLoading
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
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  chatName: chat['username'],
                                  chatId: chat['id'],
                                  avatar: chat['avatar']),
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
