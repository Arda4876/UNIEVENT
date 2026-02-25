import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedCity = 'İstanbul';
  List<String> _selectedInterests = [];

  final List<String> _cities = ['İstanbul', 'Ankara', 'İzmir', 'Bursa'];
  final List<String> _interests = ['Seminer', 'Konferans', 'Workshop', 'Kulüp'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Şehrinizi Seçin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedCity,
              items: _cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'İlgi Alanlarınızı Seçin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._interests.map((interest) {
              return CheckboxListTile(
                title: Text(interest),
                value: _selectedInterests.contains(interest),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save preferences
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tercihler kaydedildi')),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
