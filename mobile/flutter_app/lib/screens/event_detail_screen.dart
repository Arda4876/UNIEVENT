import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../widgets/app_drawer.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'tr_TR');

    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinlik Detayları'),
        backgroundColor: Color(0xFF6366F1),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.imageUrl ?? 'https://via.placeholder.com/400x250',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                        child: Icon(
                          Icons.event,
                          size: 80,
                          color: Color(0xFF6366F1),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(event.category),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryLabel(event.category),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Rating and Attendees
                  if (event.attendees != null)
                    Row(
                      children: [
                        Icon(Icons.people, size: 18, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text(
                          '${event.attendees} kişi katılacak',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),

                  // Info Cards
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Tarih & Saat',
                          value: dateFormat.format(event.date),
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.location_on,
                          label: 'Yer',
                          value: event.location,
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.school,
                          label: 'Üniversite',
                          value: event.university,
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.place,
                          label: 'Şehir',
                          value: event.city,
                        ),
                        if (event.speaker != null) ...[
                          SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.person,
                            label: 'Konuşmacı',
                            value: event.speaker!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Description
                  Text(
                    'Etkinlik Hakkında',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    event.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Price and Button
                  if (event.price != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fiyat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bilet Fiyatı',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '₺${event.price!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Etkinlik kaydedildi'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(Icons.bookmark),
                          label: Text('Kaydet'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF6366F1),
                            side: BorderSide(color: Color(0xFF6366F1)),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/payment',
                              arguments: event,
                            );
                          },
                          icon: Icon(Icons.shopping_cart),
                          label: Text('Bilet Al'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6366F1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Additional Info
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.blue[200] ?? Colors.blue),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event.isOpenToExternal
                                ? 'Bu etkinlik dışarıdan katılıma açıktır'
                                : 'Bu etkinlik sadece İç katılımcılara açıktır',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF6366F1), size: 24),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'concerts':
        return Colors.red;
      case 'seminars':
        return Colors.blue;
      case 'news':
        return Colors.green;
      case 'events':
        return Colors.orange;
      default:
        return Color(0xFF6366F1);
    }
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'concerts':
        return 'Konser';
      case 'seminars':
        return 'Seminer';
      case 'news':
        return 'Haber';
      case 'events':
        return 'Etkinlik';
      default:
        return category;
    }
  }
}
