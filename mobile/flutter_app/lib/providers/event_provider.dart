import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  final EventService _eventService = EventService();

  void loadEvents() {
    _events = _eventService.fetchEvents();
    notifyListeners();
  }

  List<Event> getPersonalizedEvents(String city, List<String> interests) {
    return _events.where((event) {
      return event.city == city && interests.contains(event.category);
    }).toList();
  }
}
