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
  // Handle potential single-word fullName
  final fullNameParts = (json['fullName'] ?? '').split(' ');
  final firstName = fullNameParts.isNotEmpty ? fullNameParts[0] : '';
  final lastName = fullNameParts.length > 1 ? fullNameParts.sublist(1).join(' ') : '';

  return User(
    id: json['id'].toString(),
    email: json['email'] ?? '',
    firstName: firstName,
    lastName: lastName,
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role']['name'].toUpperCase(),
      orElse: () => UserRole.admin,
    ),
    createdAt: DateTime.parse(json['createdAt']??"2022-12-03"),
    isActive: json['active'] ?? true,
  );
}
}
