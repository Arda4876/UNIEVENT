import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback? onBuyTap;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    this.onBuyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy - HH:mm', 'tr_TR');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.imageUrl ?? 'https://via.placeholder.com/400x200',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFF6366F1).withOpacity(0.2),
                        child: Icon(
                          Icons.event,
                          size: 48,
                          color: Color(0xFF6366F1),
                        ),
                      );
                    },
                  ),
                  // Category Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            _getCategoryColor(event.category).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryLabel(event.category),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 13, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dateFormat.format(event.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 13, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Bottom row with price and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (event.price != null)
                        Text(
                          '₺${event.price!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: onBuyTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6366F1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Bilet Al',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
