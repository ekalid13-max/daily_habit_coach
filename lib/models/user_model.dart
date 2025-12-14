import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final bool premium;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.premium,
    required this.createdAt,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) =>
      UserModel(
        id: id,
        email: data['email'],
        name: data['name'],
        premium: data['premium'] ?? false,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'premium': premium,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}

