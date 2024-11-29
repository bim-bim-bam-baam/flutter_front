import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  // Список людей
  final List<Map<String, dynamic>> _people = [
    {'name': 'Alice', 'similarity': 95, 'age': 25},
    {'name': 'Bob', 'similarity': 88, 'age': 30},
    {'name': 'Charlie', 'similarity': 80, 'age': 22},
    {'name': 'Diana', 'similarity': 75, 'age': 27},
  ];

  // Фильтры
  String _selectedAgeGroup = 'All Ages';
  final List<String> _ageGroups = ['All Ages', '18-25', '26-35', '36+'];

  @override
  Widget build(BuildContext context) {
    // Применение фильтра
    List<Map<String, dynamic>> filteredPeople = _people;

    if (_selectedAgeGroup != 'All Ages') {
      filteredPeople = _people.where((person) {
        final age = person['age'] as int;
        if (_selectedAgeGroup == '18-25') return age >= 18 && age <= 25;
        if (_selectedAgeGroup == '26-35') return age >= 26 && age <= 35;
        if (_selectedAgeGroup == '36+') return age > 35;
        return true;
      }).toList();
    }

    // Сортировка по убыванию похожести
    filteredPeople.sort((a, b) => b['similarity'].compareTo(a['similarity']));

    return Scaffold(
      backgroundColor: Colors.black, // Фон страницы черный
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Фильтры
            DropdownButtonFormField<String>(
              value: _selectedAgeGroup,
              decoration: InputDecoration(
                labelText: 'Filter by Age',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: _ageGroups
                  .map((group) => DropdownMenuItem(
                        value: group,
                        child: Text(group),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAgeGroup = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Список людей
            Expanded(
              child: ListView.builder(
                itemCount: filteredPeople.length,
                itemBuilder: (context, index) {
                  final person = filteredPeople[index];
                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Text(
                          person['name'][0], // Первая буква имени
                          style: const TextStyle(
                            color: Colors.white,
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
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      onTap: () {
                        // Логика при нажатии на карточку
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
}
