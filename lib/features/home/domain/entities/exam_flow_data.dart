import 'package:equatable/equatable.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';

class ExamFlowData extends Equatable {
  const ExamFlowData({
    required this.law,
    required this.level,
    required this.materials,
  });

  final Law law;
  final LawLevel level;
  final List<LawMaterial> materials;

  @override
  List<Object?> get props => [law, level, materials];
}
