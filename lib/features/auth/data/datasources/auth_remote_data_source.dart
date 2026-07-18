import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/features/auth/data/models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthUserModel> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleInitializeFuture = GoogleSignIn.instance.initialize();

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Future<void> _googleInitializeFuture;

  @override
  Future<AuthUserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException();
      final model = AuthUserModel.fromFirebaseUser(user);
      await _saveUser(model);
      return model;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseAuthMessage(error));
    }
  }

  @override
  Future<AuthUserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException();

      await user.updateDisplayName(name.trim());
      final model = AuthUserModel.fromFirebaseUser(
        user,
      ).copyWithName(name.trim());
      await _saveUser(model);
      return model;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseAuthMessage(error));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر حفظ بيانات المستخدم');
    }
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      await _googleInitializeFuture;
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw const AuthException(
          'تسجيل الدخول بجوجل غير مدعوم على هذه المنصة',
        );
      }

      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) throw const AuthException();

      final model = AuthUserModel.fromFirebaseUser(user);
      await _saveUser(model);
      return model;
    } on GoogleSignInException catch (error) {
      throw AuthException(error.description ?? 'تم إلغاء تسجيل الدخول بجوجل');
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseAuthMessage(error));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر حفظ بيانات المستخدم');
    }
  }

  Future<void> _saveUser(AuthUserModel user) async {
    final doc = _firestore.collection('users').doc(user.id);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      await doc.set(user.toUpdateJson(), SetOptions(merge: true));
      return;
    }

    await doc.set(user.toCreateJson());
  }

  String _mapFirebaseAuthMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'هذا البريد مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة';
      case 'network-request-failed':
        return 'تحقق من اتصال الإنترنت';
      default:
        return error.message ?? 'تعذر إتمام عملية المصادقة';
    }
  }
}

extension on AuthUserModel {
  AuthUserModel copyWithName(String name) {
    return AuthUserModel(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lastLoginDate: lastLoginDate,
    );
  }
}
