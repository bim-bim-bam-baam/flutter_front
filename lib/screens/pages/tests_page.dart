import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swipe_cards/swipe_cards.dart';

import '../../constants/constants.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  String _selectedCategory = '';
  List<String> _categories = [];
  List<String> _questions = [];
  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Получаем все категории с бекенда
  Future<void> _loadCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/category/all'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _categories =
              data.map((category) => category['name'] as String).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Получаем следующий вопрос для выбранной категории
  Future<void> _loadNextQuestion(String categoryId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/question/getNextQuestion?id=$categoryId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['question'] != null) {
          setState(() {
            _questions.add(data['question'] as String);
            _initializeSwipeItems();
          });
        }
      } else {
        throw Exception('Failed to load question');
      }
    } catch (e) {
      print('Error loading question: $e');
    }
  }

  // Инициализация карточек для Swipe
  void _initializeSwipeItems() {
    _swipeItems = _questions.map((question) {
      return SwipeItem(
        content: question,
        likeAction: () => print('Liked: $question'),
        nopeAction: () => print('Disliked: $question'),
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
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
              value: _selectedCategory,
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
                    _loadNextQuestion(
                        value); // Получаем первый вопрос для выбранной категории
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
                        final question = _swipeItems[index].content as String;

                        // Разделение текста на левые и правые варианты
                        final parts = question.split(' or ');
                        final leftOption =
                            parts.isNotEmpty ? parts[0] : 'Option 1';
                        final rightOption =
                            parts.length > 1 ? parts[1] : 'Option 2';

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
