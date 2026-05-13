enum BookingPlans {
  hourly,
  day,
  tailored,
  bundle,
  privateOffice,
  eventSpace,
  meetingSpace,
}

enum LevelProgressStatus {
  notStarted('not_started'),
  inProgress('in_progress'),
  completed('completed');

  const LevelProgressStatus(this.value);

  final String value;

  static LevelProgressStatus fromValue(String value) {
    return LevelProgressStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LevelProgressStatus.notStarted,
    );
  }
}

enum ExamSessionStatus {
  inProgress('in_progress'),
  completed('completed');

  const ExamSessionStatus(this.value);

  final String value;

  static ExamSessionStatus fromValue(String value) {
    return ExamSessionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ExamSessionStatus.inProgress,
    );
  }
}
