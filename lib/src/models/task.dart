import 'dart:ui';

class Task {
  final int hours;
  final int minutes;
  final double ec;
  final int duration;
  final String action;

  Task(this.hours, this.minutes, this.ec, this.duration, this.action);

  Task.fromJson(Map<String, dynamic> json)
      : hours = json['Hours'] as int,
        minutes = json['Minutes'] as int,
        ec = json['Ec'] as double,
        duration = json['Duration'] as int,
        action = json['Action'] as String;

  Map<String, dynamic> toJson() => {
        'Hours': hours,
        'Minutes': minutes,
        'Ec': ec,
        'Duration': duration,
        'Action': action
      };

  @override
  String toString() {
    return "Task{${toJson()}}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is Task &&
      o.hours == hours &&
      o.minutes == minutes &&
      o.ec == ec &&
      o.duration == duration &&
      o.action == action;

  @override
  int get hashCode => hashValues(hours, minutes, ec, duration, action);
}
