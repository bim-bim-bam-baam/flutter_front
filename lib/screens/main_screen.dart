import 'package:flutter/material.dart';
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

  final List<Widget> _pages = [
    const TestsPage(), // Tests
    const PeoplePage(),  // Home
    const MessengerPage(), // Messenger
  ];

  final List<String> _titles = ['Tests', 'Home', 'Messenger'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white), // Белый текст заголовка
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white), // Белая иконка профиля
            onPressed: () {
              // Переход на страницу профиля
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white), // Белый цвет для иконок
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.deepPurple, // Фиолетовый фон нижней панели
        selectedItemColor: Colors.white, // Белый цвет активной вкладки
        unselectedItemColor: Colors.grey[400], // Серый цвет неактивных вкладок
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Tests'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messenger'),
        ],
      ),
    );
  }
}
