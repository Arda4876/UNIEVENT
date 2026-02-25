class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String category;
  final bool isOpenToExternal;
  final String? ticketUrl;
  final String university;
  final String city;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    required this.isOpenToExternal,
    this.ticketUrl,
    required this.university,
    required this.city,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      category: json['category'],
      isOpenToExternal: json['isOpenToExternal'],
      ticketUrl: json['ticketUrl'],
      university: json['university'],
      city: json['city'],
      imageUrl: json['imageUrl'],
    );
  }
}
