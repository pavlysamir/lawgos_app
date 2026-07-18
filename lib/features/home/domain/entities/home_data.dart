import 'package:equatable/equatable.dart';
import 'package:lowgos_app/features/home/domain/entities/home_user.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

class HomeData extends Equatable {
  const HomeData({
    required this.user,
    required this.laws,
    required this.progressLaws,
  });

  final HomeUser user;
  final List<Law> laws;
  final List<Law> progressLaws;

  @override
  List<Object?> get props => [user, laws, progressLaws];
}
