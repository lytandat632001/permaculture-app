class DeviceSummary {
  final int total;
  final int online;
  final int offline;
  final int running;
  final int runningTooLong;
  final int offlineTooLong;
  final int error;

  const DeviceSummary({
    required this.total,
    required this.online,
    required this.offline,
    required this.running,
    required this.runningTooLong,
    required this.offlineTooLong,
    required this.error,
  });
}
