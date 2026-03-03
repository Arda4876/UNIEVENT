import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/category_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniEventAI'),
        centerTitle: true,
        backgroundColor: Color(0xFF6366F1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: const HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Ara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6366F1),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<void> _loadFuture;
  String _selectedCategory = 'all';
  final List<Map<String, dynamic>> categories = [
    {
      'id': 'all',
      'title': 'Tüm Etkinlikler',
      'icon': Icons.category,
      'color': Color(0xFF6366F1),
    },
    {
      'id': 'news',
      'title': 'Haberler',
      'icon': Icons.newspaper,
      'color': Colors.green,
    },
    {
      'id': 'events',
      'title': 'Etkinlikler',
      'icon': Icons.event,
      'color': Colors.orange,
    },
    {
      'id': 'concerts',
      'title': 'Konserler',
      'icon': Icons.music_note,
      'color': Colors.red,
    },
    {
      'id': 'seminars',
      'title': 'Seminerler',
      'icon': Icons.school,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<EventProvider>(context, listen: false);
    _loadFuture = provider.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, ${authProvider.currentUser?.username ?? "Kullanıcı"}!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Üniversite etkinliklerini keşfet',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Categories
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategoriler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      title: category['title'],
                      icon: category['icon'],
                      color: category['color'],
                      onTap: () {
                        setState(() => _selectedCategory = category['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${category['title']} kategorisi seçildi',
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Events Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Etkinlikler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<void>(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    eventProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6366F1),
                    ),
                  );
                }

                if (eventProvider.error != null) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Hata: ${eventProvider.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                List<Event> displayedEvents = eventProvider.events;

                if (_selectedCategory != 'all') {
                  displayedEvents = displayedEvents
                      .where(
                        (event) =>
                            event.category.toLowerCase() == _selectedCategory,
                      )
                      .toList();
                }

                if (displayedEvents.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bu kategoride etkinlik bulunamadı',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: displayedEvents.length,
                  itemBuilder: (context, index) {
                    final event = displayedEvents[index];
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
                );
              },
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
