enum UserRole { admin, educator, parent }
class Role {
  final int id;
  final String name;
  final String description;

  Role({required this.id, required this.name, required this.description});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

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
  // Handle potential single-word fullName
  final fullNameParts = (json['fullName'] ?? '').split(' ');
  final firstName = fullNameParts.isNotEmpty ? fullNameParts[0] : '';
  final lastName = fullNameParts.length > 1 ? fullNameParts.sublist(1).join(' ') : '';
  final roleString = json['role']['name']?.toString().toLowerCase() ?? '';
  final role = UserRole.values.firstWhere(
    (e) => e.name == roleString,
    orElse: () => throw FormatException('Invalid user role: $roleString'),
  );
  return User(
    id: json['id'].toString(),
    email: json['email'] ?? '',
    firstName: firstName,
    lastName: lastName,
    role:role,
    createdAt: DateTime.parse(json['createdAt']??"2022-12-03"),
    isActive: json['active'] ?? true,
  );
}
}
