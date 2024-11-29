import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final List<Map<String, dynamic>> _people = [
    {'name': 'Alice', 'similarity': 95, 'age': 25, 'bio': 'Loves hiking and painting.'},
    {'name': 'Bob', 'similarity': 88, 'age': 30, 'bio': 'Enjoys cycling and jazz music.'},
    {'name': 'Charlie', 'similarity': 80, 'age': 22, 'bio': 'Aspiring chef and foodie.'},
    {'name': 'Diana', 'similarity': 75, 'age': 27, 'bio': 'Tech enthusiast and gamer.'},
  ];

  String _selectedAgeGroup = 'All Ages';
  final List<String> _ageGroups = ['All Ages', '18-25', '26-35', '36+'];

  @override
  Widget build(BuildContext context) {
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

    filteredPeople.sort((a, b) => b['similarity'].compareTo(a['similarity']));

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedAgeGroup,
              decoration: InputDecoration(
                labelText: 'Filter by Age',
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
              items: _ageGroups
                  .map((group) => DropdownMenuItem(
                        value: group,
                        child: Text(
                          group,
                          style: const TextStyle(color: Colors.white),
                        ),
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
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFFBB86FC),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Иконка закрытия в верхнем правом углу
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Кнопка "Invite Message"
                    ElevatedButton(
                      onPressed: () {
                        // Логика отправки приглашения
                        Navigator.pop(context); // Закрыть окно (опционально)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBB86FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
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
              ],
            ),
          ),
        );
      },
    );
  }
}