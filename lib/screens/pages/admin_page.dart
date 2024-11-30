import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

String decodeUtf8(String input) {
  return utf8.decode(Uint8List.fromList(input.codeUnits));
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _selectedCategory = ''; // Переменная для выбранной категории
  List<String> _categories = []; // Список категорий
  Map<String, String> _categoryMap = {}; // Словарь для ID категорий
  bool isLoading = true;

  // Переменные для текстовых полей
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerLeftController = TextEditingController();
  TextEditingController _answerRightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Получаем категории с бэкенда
  Future<void> _loadCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/category/all'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        setState(() {
          _categories = data.map((category) {
            var name = category['name'];
            return name is String ? name : name.toString(); // Убедимся, что это строка
          }).toList();

          // Создание map для категорий и их ID
          _categoryMap = {
            for (var item in data)
              item['name'] is String ? item['name'] : item['name'].toString():
                  (item['id'] is String ? item['id'] : item['id'].toString())
          };

          // Если категории доступны, выбираем первую
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories[0];
            isLoading = false;
          }
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendQuestion() async {
  if (_questionController.text.trim().isEmpty ||
      _answerLeftController.text.trim().isEmpty ||
      _answerRightController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All fields must be filled')),
    );
    return;
  }

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final questionContent = _questionController.text.trim();
    final answerLeft = _answerLeftController.text.trim();
    final answerRight = _answerRightController.text.trim();
    final categoryId = _categoryMap[_selectedCategory];

    if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category is not selected')),
      );
      return;
    }

    // Формируем строку, которую отправим на сервер
    final requestBody = '''
{
  "questionContent": "$questionContent",
  "answerLeft": "$answerLeft",
  "answerRight": "$answerRight",
  "categoryId": $categoryId
}
''';

    final response = await http.post(
      Uri.parse('$baseUrl/question/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Указываем, что это JSON
      },
      body: requestBody, // Отправляем строку как тело запроса
    );

    if (response.statusCode == 200) {
      print('Question added successfully');
      setState(() {
        _questionController.clear();
        _answerLeftController.clear();
        _answerRightController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question added successfully')),
      );
    } else {
      print('Failed to add question: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (e) {
    print('Error sending question: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Дропдаун для выбора категории
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    value: _selectedCategory.isEmpty ? null : _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF64FFDA)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dropdownColor: const Color(0xFF1E1E1E),
                    style: const TextStyle(color: Colors.white),
                    items: _categories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
            const SizedBox(height: 20),

            // Текстовое поле для ввода вопроса
            TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Question',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF64FFDA)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Текстовое поле для варианта ответа 1
            TextField(
              controller: _answerLeftController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Answer 1',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF64FFDA)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Текстовое поле для варианта ответа 2
            TextField(
              controller: _answerRightController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Answer 2',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF64FFDA)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Неоновая кнопка для отправки вопроса
            ElevatedButton(
              onPressed: _sendQuestion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.white),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.send, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Send Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
