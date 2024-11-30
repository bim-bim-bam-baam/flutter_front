import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Color(0xFF64FFDA)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingOption(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: _isDarkMode,
              activeColor: const Color(0xFF64FFDA),
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.language,
            title: 'Language',
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: const Color(0xFF1E1E1E),
              items: ['English', 'Русский', 'Español', 'Deutsch']
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(
                          language,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    _selectedLanguage = value;
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: true, // Example: notifications always on
              activeColor: const Color(0xFF64FFDA),
              onChanged: (value) {
                // Logic to toggle notifications
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.lock,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Navigate to Privacy Policy
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.info,
            title: 'About',
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Navigate to About
            },
          ),
        ],
      ),
    );
  }

  // Виджет для каждого пункта настроек
  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64FFDA).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF64FFDA), size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
