import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  String _selectedCategory = 'Music';
  final List<String> _categories = ['Music', 'Movies', 'Books', 'Sports'];

  final Map<String, List<String>> _questionsByCategory = {
    'Music': ['Rock or Rap?'],
    'Movies': ['Action or Comedy?'],
    'Books': ['Fiction or Non-Fiction?'],
    'Sports': ['Football or Basketball?'],
  };

  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;

  @override
  void initState() {
    super.initState();
    _initializeSwipeItems();
  }

  void _initializeSwipeItems() {
    final questions = _questionsByCategory[_selectedCategory] ?? [];
    _swipeItems = questions.map((question) {
      return SwipeItem(
        content: question,
        likeAction: () => print('Liked: $question'),
        nopeAction: () => print('Disliked: $question'),
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  void _skipCard() {
    if (_matchEngine.currentItem != null) {
      setState(() {
        final skippedItem = _swipeItems.removeAt(0);
        _swipeItems.add(skippedItem);
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for categories
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                    _initializeSwipeItems();
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Swipe cards
            Expanded(
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (context, index) {
                  final question = _swipeItems[index].content as String;

                  return Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(-5, 5),
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Вопрос в центре сверху (белая надпись)
                        Positioned(
                          top: 40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Текст "Rock" с зеленой стрелкой (слева, под вопросом)
                        Positioned(
                          left: 20,
                          top: screenHeight * 0.4,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Colors.green,
                                size: 30,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Rock',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  shadows: [
                                    Shadow(
                                      color: Colors.green,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Текст "Rap" с фиолетовой стрелкой (справа, под вопросом)
                        Positioned(
                          right: 20,
                          top: screenHeight * 0.4,
                          child: Row(
                            children: [
                              const Text(
                                'Rap',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                  shadows: [
                                    Shadow(
                                      color: Colors.purple,
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.purple,
                                size: 30,
                              ),
                            ],
                          ),
                        ),

                        // Кнопка "Не знаю" снизу
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _skipCard,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                shadowColor: Colors.white,
                                elevation: 15,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.help_outline, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text(
                                    'Не знаю',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
