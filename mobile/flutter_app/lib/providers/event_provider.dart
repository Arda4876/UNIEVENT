import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final EventService _eventService = EventService();

  Future<void> loadEvents({String host = '192.168.0.100'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _events = await _eventService.fetchEvents(host: host);
    } catch (e) {
      _error = e.toString();
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Event> getPersonalizedEvents(String city, List<String> interests) {
    return _events.where((event) {
      return event.city == city && interests.contains(event.category);
    }).toList();
  }
}
