import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  static const String baseUrl =
      'http://localhost:3000'; // Backend URL, ama frontend sadece, mock kullan

  // Mock data for now
  static List<Event> getMockEvents() {
    return [
      Event(
        id: '1',
        title: 'Yapay Zeka Semineri',
        description: 'AI teknolojileri hakkında kapsamlı seminer.',
        date: DateTime.now().add(Duration(days: 2)),
        location: 'İstanbul Teknik Üniversitesi',
        category: 'Seminer',
        isOpenToExternal: true,
        ticketUrl: 'https://example.com/ticket1',
        university: 'İTÜ',
        city: 'İstanbul',
        imageUrl: 'https://via.placeholder.com/150?text=AI+Semineri',
      ),
      Event(
        id: '2',
        title: 'Flutter Workshop',
        description: 'Mobil uygulama geliştirme workshopu.',
        date: DateTime.now().add(Duration(days: 5)),
        location: 'Boğaziçi Üniversitesi',
        category: 'Workshop',
        isOpenToExternal: false,
        university: 'Boğaziçi',
        city: 'İstanbul',
        imageUrl: 'https://via.placeholder.com/150?text=Flutter+Workshop',
      ),
      Event(
        id: '3',
        title: 'Konferans: Geleceğin Teknolojileri',
        description: 'Teknoloji trendleri konferansı.',
        date: DateTime.now().add(Duration(days: 10)),
        location: 'ODTÜ',
        category: 'Konferans',
        isOpenToExternal: true,
        ticketUrl: 'https://example.com/ticket3',
        university: 'ODTÜ',
        city: 'Ankara',
        imageUrl: 'https://via.placeholder.com/150?text=Teknoloji+Konferansi',
      ),
    ];
  }

  // Future<List<Event>> fetchEvents() async {
  //   final response = await http.get(Uri.parse('$baseUrl/events'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => Event.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load events');
  //   }
  // }

  List<Event> fetchEvents() {
    return getMockEvents();
  }
}
