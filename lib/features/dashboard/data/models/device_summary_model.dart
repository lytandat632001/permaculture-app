import '../../domain/entities/device_summary.dart';

class DeviceSummaryModel extends DeviceSummary {
  const DeviceSummaryModel({
    required super.total,
    required super.online,
    required super.offline,
    required super.running,
    required super.runningTooLong,
    required super.offlineTooLong,
    required super.error,
  });

  factory DeviceSummaryModel.fromJson(Map<String, dynamic> json) {
    return DeviceSummaryModel(
      total: json['total'] as int,
      online: json['online'] as int,
      offline: json['offline'] as int,
      running: json['running'] as int,
      runningTooLong: json['runningTooLong'] as int,
      offlineTooLong: json['offlineTooLong'] as int,
      error: json['error'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'online': online,
    'offline': offline,
    'running': running,
    'runningTooLong': runningTooLong,
    'offlineTooLong': offlineTooLong,
    'error': error,
  };
}
