import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/domain/entities/question_answer.dart';

class LawQuestionModel extends LawQuestion {
  const LawQuestionModel({
    required super.id,
    required super.lawId,
    required super.materialId,
    required super.level,
    required super.questionText,
    required super.answers,
  });

  factory LawQuestionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LawQuestionModel(
      id: _readString(data, 'question_id', fallback: doc.id),
      lawId: _readString(data, 'law_id', fallback: ''),
      materialId: _readString(data, 'material_id', fallback: ''),
      level: _readInt(data, 'level'),
      questionText: _readString(data, 'question_text', fallback: ''),
      answers: _readAnswers(data['answers']),
    );
  }

  static List<QuestionAnswer> _readAnswers(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map<String, dynamic>>().map((item) {
      return QuestionAnswer(
        text: item['text'] is String ? item['text'] as String : '',
        isCorrect: item['is_correct'] == true,
      );
    }).toList();
  }

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  static String _readString(
    Map<String, dynamic> data,
    String key, {
    required String fallback,
  }) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }
}
