import 'package:flutter/foundation.dart';

class Config {
  final bool isChatEnabled;
  final bool isCallEnabled;
  final String workHours;

  Config({
    @required this.isChatEnabled,
    @required this.isCallEnabled,
    @required this.workHours,
  });

  static Config fromJson(dynamic json) {
    return Config(
      isChatEnabled: json['isChatEnabled'],
      isCallEnabled: json['isCallEnabled'],
      workHours: json['workHours'],
    );
  }

  bool isWithinWorkingHours() {
    final now = DateTime.now();
    final dayOfTheWeek = now.weekday;
    final hour = now.hour;
    if (dayOfTheWeek == 6 || dayOfTheWeek == 7) {
      return false;
    } else if (!(9 <= hour && hour <= 17)) {
      return false;
    }
    return true;
  }
}
