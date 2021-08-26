import 'package:flutter/foundation.dart';
import 'package:plantos/src/models/task.dart';

class Schedule {
  final String? id;
  final String name;
  final int startDay;
  final List<Task> tasks;

  Schedule({
    required this.id,
    required this.name,
    required this.startDay,
    required this.tasks,
  });

  static List<Task> parseTasks(dynamic tasks) {
    return tasks.map<Task>((json) => Task.fromJson(json)).toList();
  }

  Schedule.fromJson(String? id, Map<String, dynamic> json)
      : id = id,
        name = json['Name'] ?? "",
        startDay = json['StartDay'] ?? 0,
        tasks = json['Tasks'] == null ? [] : parseTasks(json['Tasks']);

  Map<String, dynamic> toJson() => {
        'Name': name,
        'StartDay': startDay,
        'Tasks': tasks.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() =>
      "Schedule{id=$id, name=$name, startDay=$startDay, tasks=$tasks}";

  @override
  bool operator ==(dynamic o) =>
      o is Schedule &&
      id == o.id &&
      name == o.name &&
      startDay == o.startDay &&
      tasks == o.tasks;
}
