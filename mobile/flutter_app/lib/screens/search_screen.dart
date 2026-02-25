import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    List<Event> allEvents = eventProvider.events;

    List<Event> filteredEvents = allEvents.where((event) {
      bool matchesQuery = event.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory =
          _selectedCategory == 'Tümü' || event.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Ara'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Ara',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          DropdownButton<String>(
            value: _selectedCategory,
            items: <String>['Tümü', 'Seminer', 'Konferans', 'Workshop']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: filteredEvents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
