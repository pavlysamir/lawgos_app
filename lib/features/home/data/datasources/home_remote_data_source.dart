import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/data/models/exam_session_model.dart';
import 'package:lowgos_app/features/home/data/models/leaderboard_entry_model.dart';
import 'package:lowgos_app/features/home/data/models/law_material_model.dart';
import 'package:lowgos_app/features/home/data/models/law_model.dart';
import 'package:lowgos_app/features/home/data/models/law_level_model.dart';
import 'package:lowgos_app/features/home/data/models/law_question_model.dart';
import 'package:lowgos_app/features/home/data/models/user_level_progress_model.dart';
import 'package:lowgos_app/features/home/data/models/user_law_progress_model.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_page_data.dart';

abstract class HomeRemoteDataSource {
  Future<List<LawModel>> getLaws();

  Future<List<UserLawProgressModel>> getUserProgress(String userId);

  Future<List<LawLevelModel>> getLawLevels(String lawId);

  Future<List<LawLevelModel>> getAllLawLevels(String lawId);

  Future<int> getUserCorrectAnswersCountForLaw({
    required String userId,
    required String lawId,
  });

  Future<int> getActiveQuestionsCountForLaw(String lawId);

  Future<List<UserLevelProgressModel>> getUserLevelProgress({
    required String userId,
    required String lawId,
  });

  Future<List<LawMaterialModel>> getMaterials(String lawId);

  Future<List<LawQuestionModel>> getQuestions({
    required String lawId,
    required String materialId,
    required int level,
  });

  Future<LeaderboardPageData> getLeaderboard({
    required String userId,
    String? lawId,
    LeaderboardCursor? cursor,
    int limit = 20,
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
    required String userName,
    String? userPhotoUrl,
    required Law law,
    required LawLevel level,
    required String questionId,
    required String difficulty,
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
  Future<List<LawLevelModel>> getAllLawLevels(String lawId) async {
    try {
      final snapshot = await _firestore
          .collection('law_levels')
          .where('law_id', isEqualTo: lawId)
          .orderBy('order')
          .get();

      return snapshot.docs.map(LawLevelModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل مستويات القانون');
    }
  }

  @override
  Future<int> getUserCorrectAnswersCountForLaw({
    required String userId,
    required String lawId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('user_question_progress')
          .where('userId', isEqualTo: userId)
          .where('lawId', isEqualTo: lawId)
          .where('isCorrect', isEqualTo: true)
          .get();

      return snapshot.docs.length;
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل إجابات المستخدم');
    }
  }

  @override
  Future<int> getActiveQuestionsCountForLaw(String lawId) async {
    try {
      final lawSnapshot = await _firestore.collection('laws').doc(lawId).get();
      final totalActiveQuestions = _readInt(
        lawSnapshot.data() ?? {},
        'total_active_questions',
      );
      if (totalActiveQuestions > 0) return totalActiveQuestions;

      var questionsSnapshot = await _firestore
          .collection('questions')
          .where('law_id', isEqualTo: lawId)
          .where('is_active', isEqualTo: true)
          .get();
      if (questionsSnapshot.docs.isEmpty) {
        questionsSnapshot = await _firestore
            .collection('questions')
            .where('lawId', isEqualTo: lawId)
            .where('isActive', isEqualTo: true)
            .get();
      }

      return questionsSnapshot.docs.length;
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل عدد الأسئلة');
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
  Future<List<LawQuestionModel>> getQuestions({
    required String lawId,
    required String materialId,
    required int level,
  }) async {
    try {
      var snapshot = await _firestore
          .collection('questions')
          .where('law_id', isEqualTo: lawId)
          .where('material_id', isEqualTo: materialId)
          .where('level', isEqualTo: level)
          .where('is_active', isEqualTo: true)
          .get();
      if (snapshot.docs.isEmpty) {
        snapshot = await _firestore
            .collection('questions')
            .where('lawId', isEqualTo: lawId)
            .where('materialId', isEqualTo: materialId)
            .where('level', isEqualTo: level)
            .where('isActive', isEqualTo: true)
            .get();
      }

      final docs = snapshot.docs.toList()..sort(_compareQuestions);
      return docs.map(LawQuestionModel.fromFirestore).toList();
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل الأسئلة');
    }
  }

  @override
  Future<LeaderboardPageData> getLeaderboard({
    required String userId,
    String? lawId,
    LeaderboardCursor? cursor,
    int limit = 20,
  }) async {
    try {
      final collection = _leaderboardCollection(lawId);
      final topSnapshot = await collection
          .orderBy('points', descending: true)
          .orderBy('displayName')
          .orderBy('userId')
          .limit(3)
          .get();
      final pageSnapshot = await _leaderboardPageQuery(
        collection: collection,
        cursor: cursor,
        limit: limit,
      ).get();
      final currentSnapshot = await collection.doc(userId).get();

      final topEntries = _rankEntries(
        docs: topSnapshot.docs,
        currentUserId: userId,
        offset: 0,
      );
      final offset = cursor?.rank ?? 0;
      final entries = _rankEntries(
        docs: pageSnapshot.docs,
        currentUserId: userId,
        offset: offset,
      );
      final currentUserEntry = await _currentLeaderboardEntry(
        collection: collection,
        snapshot: currentSnapshot,
        currentUserId: userId,
      );

      return LeaderboardPageData(
        topEntries: topEntries,
        entries: entries,
        currentUserEntry: currentUserEntry,
        nextCursor: pageSnapshot.docs.length < limit || entries.isEmpty
            ? null
            : (entries.last as LeaderboardEntryModel).cursor,
      );
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحميل لوحة الترتيب');
    }
  }

  CollectionReference<Map<String, dynamic>> _leaderboardCollection(
    String? lawId,
  ) {
    if (lawId == null || lawId.isEmpty) {
      return _firestore.collection('global_leaderboard');
    }
    return _firestore
        .collection('law_leaderboards')
        .doc(lawId)
        .collection('users');
  }

  Query<Map<String, dynamic>> _leaderboardPageQuery({
    required CollectionReference<Map<String, dynamic>> collection,
    required LeaderboardCursor? cursor,
    required int limit,
  }) {
    final query = collection
        .orderBy('points', descending: true)
        .orderBy('displayName')
        .orderBy('userId');

    if (cursor == null) return query.limit(limit);

    return query
        .startAfter([cursor.points, cursor.displayName, cursor.userId])
        .limit(limit);
  }

  List<LeaderboardEntryModel> _rankEntries({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    required String currentUserId,
    required int offset,
  }) {
    return List.generate(docs.length, (index) {
      return LeaderboardEntryModel.fromFirestore(
        doc: docs[index],
        rank: offset + index + 1,
        currentUserId: currentUserId,
      );
    });
  }

  Future<LeaderboardEntryModel?> _currentLeaderboardEntry({
    required CollectionReference<Map<String, dynamic>> collection,
    required DocumentSnapshot<Map<String, dynamic>> snapshot,
    required String currentUserId,
  }) async {
    if (!snapshot.exists) return null;
    final data = snapshot.data() ?? {};
    final points = _readInt(data, 'points');

    final higherPoints = await collection
        .where('points', isGreaterThan: points)
        .count()
        .get();
    final rank = (higherPoints.count ?? 0) + 1;

    return LeaderboardEntryModel.fromFirestore(
      doc: snapshot,
      rank: rank,
      currentUserId: currentUserId,
    );
  }

  int _compareQuestions(
    QueryDocumentSnapshot<Map<String, dynamic>> first,
    QueryDocumentSnapshot<Map<String, dynamic>> second,
  ) {
    final createdAtComparison = _questionCreatedAt(
      first,
    ).compareTo(_questionCreatedAt(second));
    if (createdAtComparison != 0) return createdAtComparison;

    return _questionId(first).compareTo(_questionId(second));
  }

  DateTime _questionCreatedAt(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final createdAt = doc.data()['created_at'];
    if (createdAt is Timestamp) return createdAt.toDate();
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _questionId(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final questionId = doc.data()['question_id'];
    if (questionId is String && questionId.trim().isNotEmpty) {
      return questionId;
    }
    return doc.id;
  }

  int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  int _calculateCompletionPercentage({
    required int correctAnswersCount,
    required int totalActiveQuestions,
  }) {
    if (totalActiveQuestions == 0) return 0;
    return ((correctAnswersCount / totalActiveQuestions) * 100)
        .round()
        .clamp(0, 100)
        .toInt();
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
    required String userName,
    String? userPhotoUrl,
    required Law law,
    required LawLevel level,
    required String questionId,
    required String difficulty,
    required bool isCorrect,
    required bool isLevelCompleted,
  }) async {
    try {
      final points = isCorrect ? _pointsForDifficulty(difficulty) : 0;
      final lawProgressDocId = '${userId}_${law.id}';
      final levelProgressDocId = '${userId}_${law.id}_${level.levelNumber}';
      final questionProgressDocId = '${userId}_$questionId';

      final completedLevelsCount = isLevelCompleted
          ? level.levelNumber.clamp(0, law.totalLevels).toInt()
          : law.completedLevelsCount;
      final lawProgressRef = _firestore
          .collection('user_law_progress')
          .doc(lawProgressDocId);
      final questionProgressRef = _firestore
          .collection('user_question_progress')
          .doc(questionProgressDocId);
      final lawRef = _firestore.collection('laws').doc(law.id);
      final globalLeaderboardRef = _firestore
          .collection('global_leaderboard')
          .doc(userId);
      final lawLeaderboardRef = _firestore
          .collection('law_leaderboards')
          .doc(law.id)
          .collection('users')
          .doc(userId);

      await _firestore.runTransaction((transaction) async {
        final lawProgressSnapshot = await transaction.get(lawProgressRef);
        final lawSnapshot = await transaction.get(lawRef);
        final questionProgressSnapshot = await transaction.get(
          questionProgressRef,
        );
        final shouldCountUniqueCorrect =
            isCorrect && !questionProgressSnapshot.exists;
        final pointsToAdd = shouldCountUniqueCorrect ? points : 0;
        final currentCorrectCount = _readInt(
          lawProgressSnapshot.data() ?? {},
          'correct_answer_question_count',
        );
        final correctCountAfterSubmit =
            currentCorrectCount + (shouldCountUniqueCorrect ? 1 : 0);
        final totalActiveQuestions = _readInt(
          lawSnapshot.data() ?? {},
          'total_active_questions',
        );
        final completionPercentage = _calculateCompletionPercentage(
          correctAnswersCount: correctCountAfterSubmit,
          totalActiveQuestions: totalActiveQuestions > 0
              ? totalActiveQuestions
              : law.totalQuestions,
        );

        transaction.set(lawProgressRef, {
          'userId': userId,
          'lawId': law.id,
          'lawName': law.name,
          'totalSolvedQuestions': FieldValue.increment(1),
          'correct_answer_question_count': correctCountAfterSubmit,
          'totalPoints': FieldValue.increment(pointsToAdd),
          'currentLevel': isLevelCompleted
              ? (level.levelNumber + 1).clamp(1, law.totalLevels).toInt()
              : level.levelNumber,
          'completedLevelsCount': completedLevelsCount,
          'completionPercentage': completionPercentage,
          'completion_percentage': completionPercentage,
          'lastPlayedAt': Timestamp.now(),
        }, SetOptions(merge: true));

        if (shouldCountUniqueCorrect) {
          transaction.set(questionProgressRef, {
            'userId': userId,
            'questionId': questionId,
            'lawId': law.id,
            'isCorrect': true,
            'points': points,
            'difficulty': difficulty,
            'solvedAt': Timestamp.now(),
          });
        }

        if (pointsToAdd > 0) {
          final leaderboardPayload = {
            'userId': userId,
            'displayName': userName,
            if (userPhotoUrl != null && userPhotoUrl.isNotEmpty)
              'photoUrl': userPhotoUrl,
            'points': FieldValue.increment(pointsToAdd),
            'correctQuestionsCount': FieldValue.increment(1),
            'lastScoredAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          };
          transaction.set(
            globalLeaderboardRef,
            leaderboardPayload,
            SetOptions(merge: true),
          );
          transaction.set(lawLeaderboardRef, {
            ...leaderboardPayload,
            'lawId': law.id,
            'lawName': law.name,
          }, SetOptions(merge: true));
        }

        transaction.set(
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
            'earnedPoints': FieldValue.increment(pointsToAdd),
            'startedAt': Timestamp.now(),
            if (isLevelCompleted) 'completedAt': Timestamp.now(),
          },
          SetOptions(merge: true),
        );
        transaction.set(_firestore.collection('users').doc(userId), {
          'totalAnswers': FieldValue.increment(1),
          'totalPoints': FieldValue.increment(pointsToAdd),
          'correctAnswers': FieldValue.increment(isCorrect ? 1 : 0),
          'updatedAt': Timestamp.now(),
        }, SetOptions(merge: true));
      });
    } on FirebaseException catch (error) {
      throw ServerException(error.message ?? 'تعذر تحديث التقدم');
    }
  }

  int _pointsForDifficulty(String difficulty) {
    switch (difficulty.trim().toLowerCase()) {
      case 'hard':
        return 30;
      case 'medium':
        return 20;
      case 'easy':
      default:
        return 10;
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
        'completion_percentage': percentage.clamp(0, 100).toInt(),
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
