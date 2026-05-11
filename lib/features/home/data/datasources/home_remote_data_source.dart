import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/data/models/law_model.dart';
import 'package:lowgos_app/features/home/data/models/law_level_model.dart';
import 'package:lowgos_app/features/home/data/models/user_level_progress_model.dart';
import 'package:lowgos_app/features/home/data/models/user_law_progress_model.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

abstract class HomeRemoteDataSource {
  Future<List<LawModel>> getLaws();

  Future<List<UserLawProgressModel>> getUserProgress(String userId);

  Future<List<LawLevelModel>> getLawLevels(String lawId);

  Future<List<UserLevelProgressModel>> getUserLevelProgress({
    required String userId,
    required String lawId,
  });

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

  Future<void> enterLevel({
    required String userId,
    required LawLevel level,
  });

  Future<void> updateLevelProgress({
    required String userId,
    required LawLevel level,
    required LevelProgressStatus status,
    required int solvedQuestionsCount,
    required int correctAnswersCount,
    required int earnedPoints,
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
          .where('is_active', isEqualTo: true)
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
  Future<List<LawLevelModel>> getLawLevels(String lawId) async {
    try {
      final snapshot = await _firestore
          .collection('law_levels')
          .where('law_id', isEqualTo: lawId)
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      return snapshot.docs.map(LawLevelModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل مستويات القانون');
    }
  }

  @override
  Future<List<UserLevelProgressModel>> getUserLevelProgress({
    required String userId,
    required String lawId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('user_level_progress')
          .where('userId', isEqualTo: userId)
          .where('lawId', isEqualTo: lawId)
          .get();

      return snapshot.docs.map(UserLevelProgressModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل تقدم المستويات');
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

  @override
  Future<void> enterLevel({
    required String userId,
    required LawLevel level,
  }) async {
    try {
      final docId = '${userId}_${level.lawId}_${level.levelNumber}';
      final doc = _firestore.collection('user_level_progress').doc(docId);
      final snapshot = await doc.get();

      if (snapshot.exists) return;

      final progress = UserLevelProgressModel.initial(
        userId: userId,
        level: level,
      );
      await doc.set(progress.toCreateJson());
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر فتح المستوى');
    }
  }

  @override
  Future<void> updateLevelProgress({
    required String userId,
    required LawLevel level,
    required LevelProgressStatus status,
    required int solvedQuestionsCount,
    required int correctAnswersCount,
    required int earnedPoints,
  }) async {
    try {
      final docId = '${userId}_${level.lawId}_${level.levelNumber}';
      final data = <String, dynamic>{
        'userId': userId,
        'lawId': level.lawId,
        'levelNumber': level.levelNumber,
        'status': status.value,
        'solvedQuestionsCount': solvedQuestionsCount,
        'correctAnswersCount': correctAnswersCount,
        'earnedPoints': earnedPoints,
      };

      if (status == LevelProgressStatus.inProgress) {
        data['startedAt'] = Timestamp.now();
      }
      if (status == LevelProgressStatus.completed) {
        data['completedAt'] = Timestamp.now();
      }

      await _firestore
          .collection('user_level_progress')
          .doc(docId)
          .set(data, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحديث تقدم المستوى');
    }
  }
}
