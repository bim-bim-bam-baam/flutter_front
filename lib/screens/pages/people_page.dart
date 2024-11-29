import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final List<Map<String, dynamic>> _people = [
    {
      'name': 'Alice',
      'similarity': 95,
      'age': 25,
      'category': 'Music',
      'bio': 'Loves hiking and painting.'
    },
    {
      'name': 'Bob',
      'similarity': 88,
      'age': 30,
      'category': 'Sports',
      'bio': 'Enjoys cycling and jazz music.'
    },
    {
      'name': 'Charlie',
      'similarity': 80,
      'age': 22,
      'category': 'Books',
      'bio': 'Aspiring chef and foodie.'
    },
    {
      'name': 'Diana',
      'similarity': 75,
      'age': 27,
      'category': 'Movies',
      'bio': 'Tech enthusiast and gamer.'
    },
  ];

  String _selectedCategory = 'All Categories';
  bool _isDescending = true;

  final List<String> _categories = [
    'All Categories',
    'Music',
    'Movies',
    'Books',
    'Sports'
  ];

  @override
  Widget build(BuildContext context) {
    // Фильтруем людей по выбранной категории
    List<Map<String, dynamic>> filteredPeople =
        _selectedCategory == 'All Categories'
            ? _people
            : _people
                .where((person) => person['category'] == _selectedCategory)
                .toList();

    // Сортируем список по схожести
    filteredPeople.sort((a, b) => _isDescending
        ? b['similarity'].compareTo(a['similarity'])
        : a['similarity'].compareTo(b['similarity']));

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Фильтр категорий
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Filter by Category',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFBB86FC)),
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
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Кнопка сортировки
                IconButton(
                  icon: Icon(
                    _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                    color: const Color(0xFFBB86FC),
                  ),
                  onPressed: () {
                    setState(() {
                      _isDescending = !_isDescending;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Список людей
            Expanded(
              child: ListView.builder(
                itemCount: filteredPeople.length,
                itemBuilder: (context, index) {
                  final person = filteredPeople[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFBB86FC).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFBB86FC),
                        child: Text(
                          person['name'][0],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        person['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Similarity: ${person['similarity']}%\nAge: ${person['age']}',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.mail,
                              size: 28,
                              color: Color(0xFFBB86FC),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          // Логика отправки сообщения
                        },
                      ),
                      onTap: () {
                        _showPersonDetails(context, person);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonDetails(BuildContext context, Map<String, dynamic> person) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFBB86FC),
                  child: Text(
                    person['name'][0],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  person['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Similarity: ${person['similarity']}%',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Age: ${person['age']}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bio:',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  person['bio'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBB86FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Invite Message',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
