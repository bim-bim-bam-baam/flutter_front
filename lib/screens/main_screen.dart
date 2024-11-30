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
    const PeoplePage(), // People
    const MessengerPage(), // Messenger
  ];

  final List<String> _titles = ['Questions', 'Matching', 'Messenger'];

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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Matching',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messenger',
          ),
        ],
      ),
    );
  }
}
