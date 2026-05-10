import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/features/home/data/models/law_model.dart';
import 'package:lowgos_app/features/home/data/models/user_law_progress_model.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

abstract class HomeRemoteDataSource {
  Future<List<LawModel>> getLaws();

  Future<List<UserLawProgressModel>> getUserProgress(String userId);

  Future<UserLawProgressModel> startLaw({
    required String userId,
    required Law law,
  });

  Future<void> updateLawProgress({
    required String userId,
    required Law law,
    required int completedLevelsCount,
    required int currentLevel,
    required int totalPoints,
  });

  String? getCurrentUserId();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  String? getCurrentUserId() => _firebaseAuth.currentUser?.uid;

  @override
  Future<List<LawModel>> getLaws() async {
    try {
      final snapshot = await _firestore
          .collection('laws')
          .where('is_deleted', isEqualTo: false)
          .get();

      final laws = snapshot.docs.map(LawModel.fromFirestore).toList();
      laws.sort((a, b) => a.name.compareTo(b.name));
      return laws;
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل القوانين');
    }
  }

  @override
  Future<List<UserLawProgressModel>> getUserProgress(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_law_progress')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map(UserLawProgressModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل تقدم المستخدم');
    }
  }

  @override
  Future<UserLawProgressModel> startLaw({
    required String userId,
    required Law law,
  }) async {
    try {
      final docId = '${userId}_${law.id}';
      final doc = _firestore.collection('user_law_progress').doc(docId);
      final snapshot = await doc.get();

      if (snapshot.exists) {
        await doc.set(
          {'lastPlayedAt': Timestamp.now()},
          SetOptions(merge: true),
        );
        return UserLawProgressModel.fromFirestore(await doc.get());
      }

      final progress = UserLawProgressModel.initial(userId: userId, law: law);
      await doc.set(progress.toCreateJson());
      return progress;
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر بدء القانون');
    }
  }

  @override
  Future<void> updateLawProgress({
    required String userId,
    required Law law,
    required int completedLevelsCount,
    required int currentLevel,
    required int totalPoints,
  }) async {
    try {
      final percentage = law.totalLevels == 0
          ? 0
          : ((completedLevelsCount / law.totalLevels) * 100).round();
      final docId = '${userId}_${law.id}';
      await _firestore.collection('user_law_progress').doc(docId).set({
        'userId': userId,
        'lawId': law.id,
        'lawName': law.name,
        'completionPercentage': percentage.clamp(0, 100).toInt(),
        'completedLevelsCount': completedLevelsCount,
        'currentLevel': currentLevel,
        'totalPoints': totalPoints,
        'lastPlayedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحديث تقدم القانون');
    }
  }
}
