import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/pages/messenger_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Neon App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Основной фон черный
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Белый текст AppBar
          ),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 3, 173, 162)), // Бирюзовые иконки AppBar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color.fromARGB(255, 3, 173, 162), // Бирюзовый активный элемент
          unselectedItemColor: Colors.purple, // Фиолетовый неактивный элемент
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Белый текст по умолчанию
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 3, 173, 162)), // Бирюзовые иконки по умолчанию
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 10,
            side: const BorderSide(color: Colors.purple, width: 2), // Фиолетовая рамка кнопок
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainScreen(),
        '/messenger': (context) => const MessengerPage(),
      },
    );
  }
}
