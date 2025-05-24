
import 'package:creche/data/models/parent_model.dart';

class Child {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String parentId;
  final String? medicalInfo;
  final List<String> allergies;
  final DateTime enrollmentDate;
  final bool isActive;
   final Parent parent;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.parentId,
    this.medicalInfo,
    this.allergies = const [],
    required this.enrollmentDate,
    this.isActive = true,
    required this.parent,
  });

  String get fullName => '$firstName $lastName';
  
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
       (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'parentId': parentId,
      'medicalInfo': medicalInfo,
      'allergies': allergies,
      'enrollmentDate': enrollmentDate.toIso8601String(),
      'isActive': isActive,
      //'parent' : parent
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'].toString(),
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: DateTime.parse(json['birthDate']),
      parentId: json['parent']['id'].toString(),
      medicalInfo: json['medicalInfo']??"",
      allergies: List<String>.from(json['allergies'] ?? [""]),
      enrollmentDate: DateTime.parse(json['enrollmentDate']??"0000-00-00"),
      isActive: json['isActive'] ?? true,
      parent: Parent.fromJson(json['parent']),
    );
  }
}