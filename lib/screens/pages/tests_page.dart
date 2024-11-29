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
    'Music': [
      'Rock or Rap?',
      'Classical or Pop?',
      'Jazz or Blues?',
      'EDM or Hip-hop?',
      'Indie or Alternative?',
      'Country or Folk?',
      'Live Concerts or Studio Recordings?',
      'Piano or Guitar?',
      'Solo Artists or Bands?',
      'Vinyl or Digital?'
    ],
    'Movies': [
      'Action or Comedy?',
      'Horror or Drama?',
      'Sci-Fi or Fantasy?',
      'Romance or Thriller?',
      'Superhero Movies or Documentaries?',
      'Classic Movies or Modern Films?',
      'Animated or Live-Action?',
      'Subtitles or Dubbed?',
      'Independent Films or Blockbusters?',
      'Series or Movies?'
    ],
    'Books': [
      'Fiction or Non-Fiction?',
      'Mystery or Romance?',
      'Biography or History?',
      'Fantasy or Science Fiction?',
      'Poetry or Prose?',
      'Novels or Short Stories?',
      'E-books or Paperbacks?',
      'Libraries or Bookstores?',
      'Self-Help or Philosophy?',
      'Comics or Graphic Novels?'
    ],
    'Sports': [
      'Football or Basketball?',
      'Tennis or Golf?',
      'Running or Swimming?',
      'Team Sports or Solo Sports?',
      'Gym or Outdoor Activities?',
      'Winter Sports or Summer Sports?',
      'Cycling or Hiking?',
      'Formula 1 or MotoGP?',
      'Martial Arts or Yoga?',
      'Cricket or Baseball?'
    ],
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

            // Карточки Swipe
            Expanded(
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (context, index) {
                  final question = _swipeItems[index].content as String;

                  // Разделение текста на левые и правые варианты
                  final parts = question.split(' or ');
                  final leftOption = parts.isNotEmpty ? parts[0] : 'Option 1';
                  final rightOption = parts.length > 1 ? parts[1] : 'Option 2';

                  // Проверка длины текста для определения наложения
                  final TextPainter leftTextPainter = TextPainter(
                    text: TextSpan(
                      text: leftOption,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  )..layout();
                  final TextPainter rightTextPainter = TextPainter(
                    text: TextSpan(
                      text: rightOption,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  )..layout();

                  final double textOverlapThreshold = screenWidth * 0.4;
                  final bool textOverlap =
                      leftTextPainter.width + rightTextPainter.width >
                      textOverlapThreshold;

                  return Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(-5, 5),
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Вопрос сверху карточки
                        Positioned(
                          top: screenHeight * 0.05,
                          left: 20,
                          right: 20,
                          child: Text(
                            question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: question.length > 20 ? 28 : 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Левый вариант выбора
                        Positioned(
                          left: 20,
                          top: textOverlap
                              ? screenHeight * 0.3
                              : screenHeight * 0.35,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                color: Color(0xFF64FFDA),
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                leftOption,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64FFDA),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFF64FFDA),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Правый вариант выбора
                        Positioned(
                          right: 20,
                          top: textOverlap
                              ? screenHeight * 0.4
                              : screenHeight * 0.35,
                          child: Row(
                            children: [
                              Text(
                                rightOption,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB86FC),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFFBB86FC),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFFBB86FC),
                                size: 28,
                              ),
                            ],
                          ),
                        ),

                        // Кнопка "Не знаю"
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
                                backgroundColor: const Color(0xFF1E1E1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Colors.white),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.help_outline, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Не знаю',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
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
