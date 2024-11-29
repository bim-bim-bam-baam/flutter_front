import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50], // Фон страницы
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white), // Белый текст заголовка
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white), // Белая иконка "Назад"
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
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurpleAccent,
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
                    onTap: () {
                      // Логика редактирования профиля
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      // Логика настроек
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      // Логика выхода из системы
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
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
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
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text('Cancel'),
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
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
