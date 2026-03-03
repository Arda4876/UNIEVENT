import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/app_drawer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    List<Event> allEvents = eventProvider.events;

    List<Event> filteredEvents = allEvents.where((event) {
      bool matchesQuery = event.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == 'all' ||
          event.category.toLowerCase() == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Ara'),
        backgroundColor: Color(0xFF6366F1),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Etkinlik adı veya açıklama ara',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              items: <String>['all', 'events', 'news', 'concerts', 'seminars']
                  .map((String value) {
                String label = value == 'all'
                    ? 'Tüm Kategoriler'
                    : value == 'events'
                        ? 'Etkinlikler'
                        : value == 'news'
                            ? 'Haberler'
                            : value == 'concerts'
                                ? 'Konserler'
                                : 'Seminerler';
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? 'all';
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey[300]),
                        SizedBox(height: 16),
                        Text(
                          'Etkinlik bulunamadı',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: EventCard(
                          event: event,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/event_detail',
                              arguments: event,
                            );
                          },
                          onBuyTap: () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: event,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
