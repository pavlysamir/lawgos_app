import 'package:equatable/equatable.dart';

class LawMaterial extends Equatable {
  const LawMaterial({
    required this.id,
    required this.lawId,
    required this.order,
    required this.content,
    required this.isDeleted,
  });

  final String id;
  final String lawId;
  final int order;
  final String content;
  final bool isDeleted;

  @override
  List<Object?> get props => [id, lawId, order, content, isDeleted];
}
