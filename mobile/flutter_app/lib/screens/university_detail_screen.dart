import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/university.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/app_drawer.dart';

class UniversityDetailScreen extends StatefulWidget {
  final University university;

  const UniversityDetailScreen({
    Key? key,
    required this.university,
  }) : super(key: key);

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  String _selectedCategory = 'all';
  final categories = ['all', 'news', 'events', 'concerts', 'seminars'];
  final categoryLabels = {
    'all': 'Tüm Etkinlikler',
    'news': 'Haberler',
    'events': 'Etkinlikler',
    'concerts': 'Konserler',
    'seminars': 'Seminerler',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.university.name),
        backgroundColor: Color(0xFF6366F1),
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Header
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.university.imageUrl ??
                        'https://via.placeholder.com/400x200',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                        child: Icon(
                          Icons.school,
                          size: 80,
                          color: Color(0xFF6366F1),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.university.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  widget.university.city,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.university.rating != null)
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    '${widget.university.rating}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Info Cards
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.people,
                      label: 'Öğrenci',
                      value: widget.university.studentCount != null
                          ? '${widget.university.studentCount}+'
                          : 'N/A',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.event,
                      label: 'Etkinlik',
                      value: '${widget.university.eventIds?.length ?? 0}',
                    ),
                  ),
                ],
              ),
            ),

            // Description
            if (widget.university.description != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hakkında',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.university.description!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),

            // Category Tabs
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategory == category;

                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = category);
                      },
                      label: Text(categoryLabels[category]!),
                      backgroundColor: Colors.grey[100],
                      selectedColor: Color(0xFF6366F1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Events List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<EventProvider>(
                builder: (context, eventProvider, _) {
                  var events = eventProvider.events
                      .where(
                        (event) =>
                            event.city.toLowerCase() ==
                            widget.university.city.toLowerCase(),
                      )
                      .toList();

                  if (_selectedCategory != 'all') {
                    events = events
                        .where(
                          (event) =>
                              event.category.toLowerCase() == _selectedCategory,
                        )
                        .toList();
                  }

                  if (events.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
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
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
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
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF6366F1).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF6366F1), size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6366F1),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
