import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/data/models/exam_session_model.dart';
import 'package:lowgos_app/features/home/data/models/law_material_model.dart';
import 'package:lowgos_app/features/home/data/models/law_model.dart';
import 'package:lowgos_app/features/home/data/models/law_level_model.dart';
import 'package:lowgos_app/features/home/data/models/law_question_model.dart';
import 'package:lowgos_app/features/home/data/models/user_level_progress_model.dart';
import 'package:lowgos_app/features/home/data/models/user_law_progress_model.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';

abstract class HomeRemoteDataSource {
  Future<List<LawModel>> getLaws();

  Future<List<UserLawProgressModel>> getUserProgress(String userId);

  Future<List<LawLevelModel>> getLawLevels(String lawId);

  Future<List<UserLevelProgressModel>> getUserLevelProgress({
    required String userId,
    required String lawId,
  });

  Future<List<LawMaterialModel>> getMaterials(String lawId);

  Future<LawQuestionModel?> getQuestion({
    required String lawId,
    required String materialId,
    required int level,
  });

  Future<ExamSessionModel?> getActiveExamSession({
    required String userId,
    required String lawId,
    required int level,
  });

  Future<ExamSessionModel> createExamSession({
    required String userId,
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  });

  Future<void> updateExamSession({
    required String sessionId,
    required int currentMaterialOrder,
    required int currentQuestionIndex,
    required int answeredQuestionsCount,
    required int correctAnswersCount,
    required List<String> completedMaterialIds,
    required ExamSessionStatus status,
  });

  Future<void> applyQuestionResult({
    required String userId,
    required Law law,
    required LawLevel level,
    required bool isCorrect,
    required bool isLevelCompleted,
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

  Future<void> enterLevel({required String userId, required LawLevel level});

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
  Future<List<LawMaterialModel>> getMaterials(String lawId) async {
    try {
      final snapshot = await _firestore
          .collection('materials')
          .where('law_id', isEqualTo: lawId)
          .where('is_deleted', isEqualTo: false)
          .orderBy('order')
          .get();

      return snapshot.docs.map(LawMaterialModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل نصوص المواد');
    }
  }

  @override
  Future<LawQuestionModel?> getQuestion({
    required String lawId,
    required String materialId,
    required int level,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('questions')
          .where('law_id', isEqualTo: lawId)
          .where('material_id', isEqualTo: materialId)
          .where('level', isEqualTo: level)
          .where('is_deleted', isEqualTo: false)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return LawQuestionModel.fromFirestore(snapshot.docs.first);
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل السؤال');
    }
  }

  @override
  Future<ExamSessionModel?> getActiveExamSession({
    required String userId,
    required String lawId,
    required int level,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('exam_sessions')
          .where('userId', isEqualTo: userId)
          .where('lawId', isEqualTo: lawId)
          .where('level', isEqualTo: level)
          .where('status', isEqualTo: ExamSessionStatus.inProgress.value)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ExamSessionModel.fromFirestore(snapshot.docs.first);
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر استئناف الجلسة');
    }
  }

  @override
  Future<ExamSessionModel> createExamSession({
    required String userId,
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  }) async {
    try {
      final model = ExamSessionModel.initial(
        userId: userId,
        law: law,
        level: level,
        firstMaterial: firstMaterial,
      );
      final doc = await _firestore
          .collection('exam_sessions')
          .add(model.toCreateJson());
      final snapshot = await doc.get();
      return ExamSessionModel.fromFirestore(snapshot);
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر بدء الجلسة');
    }
  }

  @override
  Future<void> updateExamSession({
    required String sessionId,
    required int currentMaterialOrder,
    required int currentQuestionIndex,
    required int answeredQuestionsCount,
    required int correctAnswersCount,
    required List<String> completedMaterialIds,
    required ExamSessionStatus status,
  }) async {
    try {
      final data = <String, dynamic>{
        'currentMaterialOrder': currentMaterialOrder,
        'currentQuestionIndex': currentQuestionIndex,
        'answeredQuestionsCount': answeredQuestionsCount,
        'correctAnswersCount': correctAnswersCount,
        'completedMaterialIds': completedMaterialIds,
        'status': status.value,
      };
      if (status == ExamSessionStatus.completed) {
        data['completedAt'] = Timestamp.now();
      }
      await _firestore
          .collection('exam_sessions')
          .doc(sessionId)
          .set(data, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر حفظ الجلسة');
    }
  }

  @override
  Future<void> applyQuestionResult({
    required String userId,
    required Law law,
    required LawLevel level,
    required bool isCorrect,
    required bool isLevelCompleted,
  }) async {
    try {
      final points = isCorrect ? 10 : 0;
      final lawProgressDocId = '${userId}_${law.id}';
      final levelProgressDocId = '${userId}_${law.id}_${level.levelNumber}';

      final completedLevelsCount = isLevelCompleted
          ? level.levelNumber.clamp(0, law.totalLevels).toInt()
          : law.completedLevelsCount;
      final completionPercentage = law.totalLevels == 0
          ? 0
          : ((completedLevelsCount / law.totalLevels) * 100).round();

      final batch = _firestore.batch();
      batch.set(
        _firestore.collection('user_law_progress').doc(lawProgressDocId),
        {
          'userId': userId,
          'lawId': law.id,
          'lawName': law.name,
          'totalSolvedQuestions': FieldValue.increment(1),
          'totalPoints': FieldValue.increment(points),
          'currentLevel': isLevelCompleted
              ? (level.levelNumber + 1).clamp(1, law.totalLevels).toInt()
              : level.levelNumber,
          'completedLevelsCount': completedLevelsCount,
          'completionPercentage': completionPercentage.clamp(0, 100).toInt(),
          'lastPlayedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
      batch.set(
        _firestore.collection('user_level_progress').doc(levelProgressDocId),
        {
          'userId': userId,
          'lawId': law.id,
          'levelNumber': level.levelNumber,
          'status': isLevelCompleted
              ? LevelProgressStatus.completed.value
              : LevelProgressStatus.inProgress.value,
          'solvedQuestionsCount': FieldValue.increment(1),
          'correctAnswersCount': FieldValue.increment(isCorrect ? 1 : 0),
          'earnedPoints': FieldValue.increment(points),
          'startedAt': Timestamp.now(),
          if (isLevelCompleted) 'completedAt': Timestamp.now(),
        },
        SetOptions(merge: true),
      );
      batch.set(_firestore.collection('users').doc(userId), {
        'totalAnswers': FieldValue.increment(1),
        'totalPoints': FieldValue.increment(points),
        'correctAnswers': FieldValue.increment(isCorrect ? 1 : 0),
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
      await batch.commit();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحديث التقدم');
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
        await doc.set({
          'lastPlayedAt': Timestamp.now(),
        }, SetOptions(merge: true));
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
