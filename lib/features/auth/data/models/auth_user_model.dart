import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    required this.createdAt,
    this.lastLoginDate,
  });

  final Timestamp createdAt;
  final Timestamp? lastLoginDate;

  factory AuthUserModel.fromFirebaseUser(User user) {
    final now = Timestamp.now();
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      createdAt: now,
      lastLoginDate: now,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'id': id,
      'name': name ?? '',
      'email': email,
      'profileImage': photoUrl,
      'createdAt': createdAt,
      'isActive': true,
      'count_completed_levels': 0,
      'totalPoints': 0,
      'correctAnswers': 0,
      'totalAnswers': 0,
      'accuracy': 0.0,
      'currentStreak': 0,
      'lastLoginDate': lastLoginDate,
      'role': 'user',
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name ?? '',
      'email': email,
      'profileImage': photoUrl,
      'isActive': true,
      'lastLoginDate': lastLoginDate ?? Timestamp.now(),
      'role': 'user',
    };
  }
}
