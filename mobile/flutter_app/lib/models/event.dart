class Event {
  final String id;
  final String title;
  final String description;
  final String category; // 'news', 'events', 'concerts', 'seminar'
  final String university;
  final DateTime date;
  final String location;
  final String? imageUrl;
  final double? price;
  final String? speaker;
  final int? attendees;
  final bool isOpenToExternal;
  final String? ticketUrl;
  final String city;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.university,
    required this.date,
    required this.location,
    this.imageUrl,
    this.price,
    this.speaker,
    this.attendees,
    this.isOpenToExternal = false,
    this.ticketUrl,
    required this.city,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      university: json['university'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      price: json['price'] as double?,
      speaker: json['speaker'] as String?,
      attendees: json['attendees'] as int?,
      isOpenToExternal: json['isOpenToExternal'] as bool? ?? false,
      ticketUrl: json['ticketUrl'] as String?,
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'university': university,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'speaker': speaker,
      'attendees': attendees,
      'isOpenToExternal': isOpenToExternal,
      'ticketUrl': ticketUrl,
      'city': city,
    };
  }
}
