import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Темный фон
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Color(0xFF64FFDA), // Мягкий зеленый неон
                blurRadius: 8,
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E), // Темный AppBar
        iconTheme: const IconThemeData(color: Color(0xFF64FFDA)), // Зеленая иконка "Назад"
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
                    backgroundColor: const Color(0xFF64FFDA), // Мягкий зеленый фон
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black, // Черная иконка
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
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
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    backgroundColor: const Color(0xFF1F2937), // Темно-зеленый фон
                    shadowColor: const Color(0xFF64FFDA), // Зеленая тень
                    onTap: () {
                      // Логика редактирования профиля
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: 'Settings',
                    backgroundColor: const Color(0xFF2D2D34), // Темно-фиолетовый фон
                    shadowColor: const Color(0xFFBB86FC), // Фиолетовая тень
                    onTap: () {
                      // Логика настроек
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Logout',
                    backgroundColor: const Color(0xFF1F2937), // Темно-зеленый фон
                    shadowColor: const Color(0xFF64FFDA), // Зеленая тень
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
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2), // Тень акцента
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: shadowColor, size: 28),
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
                style: TextStyle(color: Color(0xFF64FFDA)), // Зеленый текст
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
                backgroundColor: const Color(0xFF64FFDA), // Зеленая кнопка
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
