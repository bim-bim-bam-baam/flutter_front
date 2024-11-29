import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  // Логотип
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person_add, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Заголовок
                  Text(
                    'Create Account',
                    style: headlineStyle(context),
                  ),
                  const SizedBox(height: 20),

                  // Поле для имени пользователя
                  TextField(
                    decoration: inputDecoration('Username', Icons.person),
                  ),
                  const SizedBox(height: 20),

                  // Поле для пароля
                  TextField(
                    decoration: inputDecoration('Password', Icons.lock),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Кнопка регистрации
                  ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: buttonStyle(),
                  child: Text(
                    'Register', // Убрали const
                    style: buttonTextStyle(),
                  ),
                ),

                  const SizedBox(height: 20),

                  // Ссылка для перехода на экран логина
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

// Стиль заголовка
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


// Общий стиль полей ввода
InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
