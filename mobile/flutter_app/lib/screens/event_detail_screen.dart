import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Tarih: ${event.date.toLocal()}'),
            Text('Yer: ${event.location}'),
            Text('Üniversite: ${event.university}'),
            Text('Şehir: ${event.city}'),
            Text('Kategori: ${event.category}'),
            Text(
                'Dışarıdan Katılım: ${event.isOpenToExternal ? 'Açık' : 'Kapalı'}'),
            const SizedBox(height: 16),
            Text(event.description),
            const SizedBox(height: 16),
            if (event.ticketUrl != null)
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(event.ticketUrl!)) {
                    await launch(event.ticketUrl!);
                  }
                },
                child: const Text('Bilet Al'),
              ),
          ],
        ),
      ),
    );
  }
}
