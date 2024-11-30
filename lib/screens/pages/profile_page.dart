import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/screens/pages/edit_profile_page.dart';
import 'package:flutter_application_1/screens/pages/settings_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  File? avatar;
  String? avatarUrl;
  final ImagePicker _picker = ImagePicker();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Получение данных пользователя с сервера
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('Token not found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          username = data['username'];
          avatarUrl = data['avatar'];
        });
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Загрузка аватара
  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatar = File(pickedFile.path);
      });

      await _uploadAvatarToBackend(File(pickedFile.path));
    }
  }

  // Отправка аватара на сервер
  Future<void> _uploadAvatarToBackend(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('Token not found');
      return;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/updateAvatar'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Avatar uploaded successfully');
        _fetchUserData(); // Обновляем данные
      } else {
        print('Failed to upload avatar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading avatar: $e');
    }
  }

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
        iconTheme: const IconThemeData(
            color: Color(0xFF64FFDA)), // Зеленая иконка "Назад"
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          const Color(0xFF64FFDA), // Мягкий зеленый фон
                      backgroundImage: avatar != null
                          ? FileImage(avatar!)
                          : (avatarUrl != null
                              ? NetworkImage(avatarUrl!)
                              : null) as ImageProvider?,
                      child: (avatar == null && avatarUrl == null)
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black, // Черная иконка
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    username ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Linux Enjoyer',
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
                    backgroundColor:
                        const Color(0xFF1F2937), // Темно-зеленый фон
                    shadowColor: const Color(0xFF64FFDA), // Зеленая тень
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: 'Settings',
                    backgroundColor:
                        const Color(0xFF2D2D34), // Темно-фиолетовый фон
                    shadowColor: const Color(0xFFBB86FC), // Фиолетовая тень
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: 'Logout',
                    backgroundColor:
                        const Color(0xFF1F2937), // Темно-зеленый фон
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
                  (Route<dynamic> route) => false,
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
