import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Черный фон
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white, // Белый текст заголовка
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E), // Темный AppBar
        iconTheme: const IconThemeData(color: Color(0xFF4ADE80)), // Зеленая иконка "Назад"
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Аватар и имя пользователя
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF4ADE80), // Мягкий зеленый
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Белый текст
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70, // Мягкий белый
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Настройки профиля
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    context,
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    color: const Color(0xFF4ADE80), // Зеленый акцент
                    onTap: () {
                      // Логика редактирования профиля
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    color: const Color(0xFFBB86FC), // Фиолетовый акцент
                    onTap: () {
                      // Логика настроек
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    color: const Color(0xFF4ADE80), // Зеленый акцент
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Виджет кнопки профиля
  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFF1E1E1E), // Темный фон карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color, // Цвет акцента
          child: Icon(icon, color: Colors.black), // Черная иконка
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Диалог выхода
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), // Темный фон
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF4ADE80)), // Зеленый текст
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false, // Удалить все предыдущие маршруты
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ADE80), // Зеленая кнопка
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black), // Черный текст
              ),
            ),
          ],
        );
      },
    );
  }
}
