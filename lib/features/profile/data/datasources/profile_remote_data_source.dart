import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/features/profile/data/models/profile_data_model.dart';

abstract class ProfileRemoteDataSource {
  String? getCurrentUserId();

  Future<ProfileDataModel> getProfileData({
    required String userId,
    required String cachedUserName,
    required String cachedEmail,
  });

  Future<ProfileDataModel> updateProfile({
    required String userId,
    required String name,
    required String email,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> logout();

  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  String? getCurrentUserId() => _firebaseAuth.currentUser?.uid;

  @override
  Future<ProfileDataModel> getProfileData({
    required String userId,
    required String cachedUserName,
    required String cachedEmail,
  }) async {
    try {
      final document = await _firestore.collection('users').doc(userId).get();
      return ProfileDataModel.fromUserDocument(
        document: document,
        cachedUserName: cachedUserName,
        cachedEmail: cachedEmail,
      );
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل بيانات الملف الشخصي');
    }
  }

  @override
  Future<ProfileDataModel> updateProfile({
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('برجاء تسجيل الدخول مرة أخرى');
      }

      final trimmedName = name.trim();
      final trimmedEmail = email.trim();
      await user.updateDisplayName(trimmedName);
      if (trimmedEmail.isNotEmpty && trimmedEmail != user.email) {
        await user.verifyBeforeUpdateEmail(trimmedEmail);
      }

      final userDoc = _firestore.collection('users').doc(userId);
      await userDoc.set({
        'name': trimmedName,
        'email': trimmedEmail,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
      await _firestore.collection('global_leaderboard').doc(userId).set({
        'displayName': trimmedName,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));

      final document = await userDoc.get();
      return ProfileDataModel.fromUserDocument(
        document: document,
        cachedUserName: trimmedName,
        cachedEmail: trimmedEmail,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapUpdateProfileMessage(error));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تعديل بيانات الملف الشخصي');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapPasswordResetMessage(error));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthException(error.message ?? 'تعذر تسجيل الخروج');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException('برجاء تسجيل الدخول مرة أخرى');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'isDeleted': true,
        'isActive': false,
        'deletedAt': Timestamp.now(),
      }, SetOptions(merge: true));
      try {
        await user.delete();
      } on FirebaseAuthException {
        await _firestore.collection('users').doc(user.uid).set({
          'isDeleted': false,
          'isActive': true,
          'deletedAt': FieldValue.delete(),
        }, SetOptions(merge: true));
        rethrow;
      }
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapDeleteAccountMessage(error));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر حذف الحساب');
    }
  }

  String _mapDeleteAccountMessage(FirebaseAuthException error) {
    if (error.code == 'requires-recent-login') {
      return 'برجاء تسجيل الدخول مرة أخرى قبل حذف الحساب';
    }
    return error.message ?? 'تعذر حذف الحساب';
  }

  String _mapUpdateProfileMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'email-already-in-use':
        return 'هذا البريد مستخدم بالفعل';
      case 'requires-recent-login':
        return 'برجاء تسجيل الدخول مرة أخرى قبل تعديل البريد الإلكتروني';
      default:
        return error.message ?? 'تعذر تعديل بيانات الملف الشخصي';
    }
  }

  String _mapPasswordResetMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد الإلكتروني';
      case 'network-request-failed':
        return 'تحقق من اتصال الإنترنت';
      default:
        return error.message ?? 'تعذر إرسال رابط تغيير كلمة المرور';
    }
  }
}
