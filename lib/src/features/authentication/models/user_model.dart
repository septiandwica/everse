import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final Timestamp createdAt;

  // Constructor with named parameters
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // toJson method to convert UserModel to a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  // fromSnapshot method to create UserModel from Firestore snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
