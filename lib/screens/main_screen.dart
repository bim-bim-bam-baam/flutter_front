import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/screens/pages/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screens/pages/people_page.dart';
import '../../screens/pages/tests_page.dart';
import '../../screens/pages/messenger_page.dart';
import '../../screens/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isAdmin = false; // Флаг для проверки статуса администратора

  final List<Widget> _pages = [
    const TestsPage(), // Tests
    const PeoplePage(), // People
    const MessengerPage(), // Messenger
    const AdminPage(), // Admin
  ];

  final List<String> _titles = ['Tests', 'People', 'Messenger', 'Create'];

  @override
  void initState() {
    super.initState();
    _checkAdminStatus(); // Проверка статуса администратора при старте
  }

  // Функция для проверки статуса админа
  Future<void> _checkAdminStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token'); // Получаем токен из SharedPreferences

      if (token == null) {
        throw Exception('Token is not available');
      }

      // Отправка запроса на сервер для проверки статуса админа
      final response = await http.get(
        Uri.parse('$baseUrl/user/isAdmin'), // Замените на ваш URL
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("!!!!!!!!!!!");
        final data = response.body;
        print(data);
        setState(() {
          _isAdmin = data == "true"; // Предполагается, что ответ содержит поле isAdmin
        });
      } else {
        print('Failed to check admin status: ${response.body}');
      }
    } catch (e) {
      print('Error checking admin status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.green,
                blurRadius: 5,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Tests',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messenger',
          ),
          if (_isAdmin) // Добавляем пункт "Admin" только если это администратор
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ],
      ),
    );
  }
}
