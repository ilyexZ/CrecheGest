// lib/data/models/parent_request_model.dart
class ParentRequest {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;
  final String status; // 'pending', 'approved', 'rejected'

  ParentRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.status,
  });

  factory ParentRequest.fromJson(Map<String, dynamic> json) {
    return ParentRequest(
      id: json['id'].toString(),
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'].toString(),
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }
}