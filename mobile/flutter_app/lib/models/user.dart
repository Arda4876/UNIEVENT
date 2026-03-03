class User {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String? profileImage;
  final String userType; // 'student' or 'regular'
  final String? university;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.profileImage,
    required this.userType,
    this.university,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String?,
      userType: json['userType'] as String,
      university: json['university'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'profileImage': profileImage,
      'userType': userType,
      'university': university,
    };
  }
}
