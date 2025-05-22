class Parent {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final List<String> childrenIds;
  final bool isActive;

  Parent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.childrenIds = const [],
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'childrenIds': childrenIds,
      'isActive': isActive,
    };
  }

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phone'],
      address: json['address'],
      childrenIds: List<String>.from(json['childrenIds'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }
}