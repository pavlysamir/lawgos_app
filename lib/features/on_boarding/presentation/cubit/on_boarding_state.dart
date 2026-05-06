import 'package:equatable/equatable.dart';

abstract class OnBoardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnBoardingInitial extends OnBoardingState {}

class OnBoardingPageChanged extends OnBoardingState {
  final int index;

  OnBoardingPageChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class OnBoardingCompleted extends OnBoardingState {}
