import 'package:equatable/equatable.dart';

class HomeUser extends Equatable {
  const HomeUser({
    required this.id,
    required this.name,
    this.profileImage,
  });

  final String id;
  final String name;
  final String? profileImage;

  @override
  List<Object?> get props => [id, name, profileImage];
}
