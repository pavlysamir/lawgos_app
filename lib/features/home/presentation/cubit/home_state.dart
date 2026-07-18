import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.data,
    this.selectedLawIndex = 0,
    this.selectedTabIndex = 0,
    this.isStartingLaw = false,
  });

  final HomeData data;
  final int selectedLawIndex;
  final int selectedTabIndex;
  final bool isStartingLaw;

  HomeSuccess copyWith({
    HomeData? data,
    int? selectedLawIndex,
    int? selectedTabIndex,
    bool? isStartingLaw,
  }) {
    return HomeSuccess(
      data: data ?? this.data,
      selectedLawIndex: selectedLawIndex ?? this.selectedLawIndex,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isStartingLaw: isStartingLaw ?? this.isStartingLaw,
    );
  }

  @override
  List<Object?> get props => [
    data,
    selectedLawIndex,
    selectedTabIndex,
    isStartingLaw,
  ];
}

class HomeError extends HomeState {
  const HomeError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
