import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool emailVerified;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.emailVerified = false,
    this.phoneNumber,
  });

  // Factory: Create from Firebase User
  factory UserModel.fromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
    );
  }

  // Factory: Create from JSON (API or SharedPreferences)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  // Convert to JSON for saving (e.g., Hive, SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
    };
  }
}
