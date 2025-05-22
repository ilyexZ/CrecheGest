class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String position;
  final DateTime hireDate;
  final String? phoneNumber;
  final bool isActive;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.position,
    required this.hireDate,
    this.phoneNumber,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'position': position,
      'hireDate': hireDate.toIso8601String(),
      'phoneNumber': phoneNumber,
      'isActive': isActive,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      position: json['position'],
      hireDate: DateTime.parse(json['hireDate']),
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'] ?? true,
    );
  }
}
