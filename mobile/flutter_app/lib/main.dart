import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/university_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/university_detail_screen.dart';
import 'screens/payment_screen.dart';
import 'models/event.dart';
import 'models/university.dart';

void main() {
  runApp(const UniEventApp());
}

class UniEventApp extends StatelessWidget {
  const UniEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UniversityProvider()),
      ],
      child: MaterialApp(
        title: 'UniEventAI',
        theme: ThemeData(
          primaryColor: Color(0xFF6366F1),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        locale: Locale('tr', 'TR'),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/event_detail': (context) => const EventDetailScreen(),
          '/search': (context) => const SearchScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/universities': (context) => const UniversitiesScreen(),
          '/university_detail': (context) {
            final university =
                ModalRoute.of(context)!.settings.arguments as University;
            return UniversityDetailScreen(university: university);
          },
          '/payment': (context) {
            final event = ModalRoute.of(context)!.settings.arguments as Event;
            return PaymentScreen(event: event);
          },
        },
      ),
    );
  }
}
