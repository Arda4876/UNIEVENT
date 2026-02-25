import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'screens/home_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

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
      ],
      child: MaterialApp(
        title: 'UniEventAI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/event_detail': (context) => const EventDetailScreen(),
          '/search': (context) => const SearchScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
