import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../constants/constants.dart';

String decodeUtf8(String input) {
  return utf8.decode(Uint8List.fromList(input.codeUnits));
}

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class QuestionItem {
  final String id;
  final String content;

  QuestionItem({required this.id, required this.content});
}

class _TestsPageState extends State<TestsPage> {
  String _selectedCategory = '';
  List<String> _categories = [];
  List<Map<String, dynamic>> _questions = [];
  Map<String, String> _categoryMap = {}; // Map для категории и её ID
  late List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _selectedCategory =
        _categories.isNotEmpty ? _categories[0] : ''; // Set a default value
  }

  // Получаем все категории с бекенда
  Future<void> _loadCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/category/all'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _categories = data.map((category) {
            var name = category['name'];
            return name is String
                ? name
                : name.toString(); // Ensuring it's a string
          }).toList();

          // Создание map для категорий и их ID
          _categoryMap = {
            for (var item in data)
              item['name'] is String ? item['name'] : item['name'].toString():
                  (item['id'] is String
                      ? item['id']
                      : item['id'].toString()) // Ensure the ID is a string
          };
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Загружаем все вопросы для выбранной категории
  Future<void> _loadAllQuestions(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final categoryId = _categoryMap[categoryName];
    final intId = int.tryParse(categoryId ?? '0');

    if (token == null) {
      print('Token not found');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/question/remainderByCategory?categoryId=$intId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = decodeUtf8(response.body);
        final data = json.decode(decodedBody) as List;

        if (data.isNotEmpty) {
          setState(() {
            _questions = data
                .map((q) => {
                      'id': q['id'], // ID вопроса
                      'content': q['content']
                    })
                .toList();
            _initializeSwipeItems();
          });
        } else {
          print("No questions found for this category");
        }
      }
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  void _initializeSwipeItems() {
    _swipeItems = _questions.map((question) {
      QuestionItem questionItem = QuestionItem(
        id: question['id'].toString(), // ID вопроса
        content: question['content'], // Текст вопроса
      );

      return SwipeItem(
        content: questionItem, // Храним сам объект вместо строки
        likeAction: () =>
            _onAnswer(questionItem.id, 1), // Используем ID объекта
        nopeAction: () => _onAnswer(questionItem.id, -1),
        superlikeAction: () => _onAnswer(questionItem.id, 0),
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Future<void> _sendAnswer(String questionId, int value) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      print('Token not found');
      return;
    }

    // print(questionId);

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/question/setAnswer?questionId=$questionId&result=$value'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Answer saved successfully for question $questionId');
      } else {
        print('Failed to save answer: ${response.body}');
      }
    } catch (e) {
      print('Error saving answer: $e');
    }
  }

  void _onAnswer(String questionId, int answer) async {
    if (_swipeItems.isNotEmpty) {
      await _sendAnswer(questionId, answer);

      setState(() {
        if (_swipeItems.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No more questions')),
          );
        }
      });
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
            // Dropdown для выбора категории
            DropdownButtonFormField<String>(
              value: _selectedCategory.isEmpty ? null : _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
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
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                    _questions.clear();
                    _loadAllQuestions(
                        value); // Получаем все вопросы для выбранной категории
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Карточки Swipe
            Expanded(
              child: _swipeItems.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (context, index) {
                        final question =
                            _swipeItems[index].content.content as String;
                        final questionId =
                            _swipeItems[index].content.id as String;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(-5, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Вопрос сверху карточки
                              Positioned(
                                top: 20,
                                left: 20,
                                right: 20,
                                child: Text(
                                  question,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Кнопка "Не знаю"
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // _onAnswer(questionId, 0);
                                      _swipeItems[index].superLike();
                                    },
                                    child: Text('Не знаю'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onStackFinished: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No more questions')),
                        );
                      },
                      upSwipeAllowed: false,
                      fillSpace: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
