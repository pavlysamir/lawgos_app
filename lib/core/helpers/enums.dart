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
