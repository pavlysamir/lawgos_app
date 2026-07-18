import 'package:equatable/equatable.dart';

class QuestionAnswer extends Equatable {
  const QuestionAnswer({required this.text, required this.isCorrect});

  final String text;
  final bool isCorrect;

  @override
  List<Object?> get props => [text, isCorrect];
}
