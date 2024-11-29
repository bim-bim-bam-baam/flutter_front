import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Для обработки JSON

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    final Uri url =
        Uri.parse('http://10.124.22.176:8080/api/user/register'); // URL сервера
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login'); // Переход на логин
      } else if (response.statusCode == 400) {
        _showError('User with such username is already exist');
      } else {
        _showError('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Failed to connect to server');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50], // Фон экрана
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8, // Тень для эффекта объёма
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child:
                        Icon(Icons.person_add, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create Account',
                    style: headlineStyle(context),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: inputDecoration('Username', Icons.person),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: inputDecoration('Password', Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register, // Вызываем функцию регистрации
                    style: buttonStyle(),
                    child: Text(
                      'Register',
                      style: buttonTextStyle(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {

Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle headlineStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ) ??
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
}

// Стиль кнопки
ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
    backgroundColor: Colors.deepPurple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

// Стиль текста кнопки
TextStyle buttonTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

// Общий стиль для полей ввода
InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}