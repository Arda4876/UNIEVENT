import 'package:flutter/material.dart';
import '../models/university.dart';

class UniversityProvider with ChangeNotifier {
  List<University> _universities = [];
  bool _isLoading = false;
  String? _error;

  List<University> get universities => _universities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UniversityProvider() {
    _loadMockUniversities();
  }

  void _loadMockUniversities() {
    _universities = [
      University(
        id: 'uni_1',
        name: 'İstanbul Üniversitesi',
        city: 'İstanbul',
        imageUrl:
            'https://via.placeholder.com/300x200?text=Istanbul+University',
        description: 'Türkiye\'nin en eski üniversitelerinden biri',
        rating: 4.5,
        studentCount: 45000,
      ),
      University(
        id: 'uni_2',
        name: 'Boğaziçi Üniversitesi',
        city: 'İstanbul',
        imageUrl:
            'https://via.placeholder.com/300x200?text=Bogazici+University',
        description: 'Prestijli eğitim kurumu',
        rating: 4.8,
        studentCount: 12000,
      ),
      University(
        id: 'uni_3',
        name: 'Ankara Üniversitesi',
        city: 'Ankara',
        imageUrl: 'https://via.placeholder.com/300x200?text=Ankara+University',
        description: 'Ankara\'nın öncü üniversitesi',
        rating: 4.3,
        studentCount: 35000,
      ),
      University(
        id: 'uni_4',
        name: 'İzmir Ekonomi Üniversitesi',
        city: 'İzmir',
        imageUrl: 'https://via.placeholder.com/300x200?text=Izmir+University',
        description: 'Ekonomi alanında uzmanlaşmış üniversite',
        rating: 4.6,
        studentCount: 8000,
      ),
      University(
        id: 'uni_5',
        name: 'Hacettepe Üniversitesi',
        city: 'Ankara',
        imageUrl:
            'https://via.placeholder.com/300x200?text=Hacettepe+University',
        description: 'Türkiye\'nin öncü araştırma üniversitesi',
        rating: 4.7,
        studentCount: 32000,
      ),
    ];
  }

  Future<void> addUniversity({
    required String name,
    required String city,
    String? imageUrl,
    String? description,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final newUniversity = University(
        id: 'uni_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        city: city,
        imageUrl: imageUrl,
        description: description,
      );

      _universities.add(newUniversity);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUniversities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // API call would go here
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
