enum UserRole { admin, educator, parent }

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final fullName = json['fullName']?.split(' ') ?? ['', ''];
    return User(
      id: json['id'],
      email: json['email'],
      firstName: fullName[0],
      lastName: fullName.length > 1 ? fullName[1] : '',
      role: UserRole.values.firstWhere(
        (e) => e.name.toLowerCase() == json['role']['name'].toLowerCase(),
      ),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }
}
