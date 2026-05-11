import 'package:equatable/equatable.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';

class LawLevelsData extends Equatable {
  const LawLevelsData({required this.law, required this.levels});

  final Law law;
  final List<LawLevel> levels;

  @override
  List<Object?> get props => [law, levels];
}
