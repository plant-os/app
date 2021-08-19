import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/recipe.dart';
import 'package:plantos/src/models/task.dart';

class Crop {
  final String? name;
  final String? id;
  final Company? company;
  final List<Camera>? cameras;
  final List<Recipe>? recipes;
  final String? ec;
  final Timestamp? startDate;
  final CropState? cropState;
  final List<Schedule>? schedules;
  final String? sensorDeviceId;

  Crop({
    this.name = "",
    this.id = "",
    this.company,
    this.cameras = const [],
    this.recipes = const [],
    this.ec = "",
    this.startDate,
    this.cropState,
    this.schedules = const [],
    this.sensorDeviceId = "",
  });

  // Return a new Crop with the given fields overwritten.
  Crop withValues({
    String? name,
    String? id,
    Company? company,
    List<Camera>? cameras,
    List<Recipe>? recipes,
    String? ec,
    Timestamp? startDate,
    CropState? cropState,
    List<Schedule>? schedules,
    bool? selected,
    String? sensorDeviceId,
  }) {
    return Crop(
      company: company ?? this.company,
      id: id ?? this.id,
      name: name ?? this.name,
      ec: ec ?? this.ec,
      startDate: startDate ?? this.startDate,
      cropState: cropState ?? this.cropState,
      schedules: schedules ?? this.schedules,
      sensorDeviceId: sensorDeviceId ?? this.sensorDeviceId,
    );
  }

  Crop.fromJson(Map<String, dynamic> json)
      : name = json['Name'] ?? null,
        id = json['Id'] ?? null,
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        cameras = json['Cameras'] != null
            ? List<Camera>.from(json["Cameras"].map((x) => Camera.fromJson(x)))
            : null,
        recipes = json['Recipes'] != null
            ? List<Recipe>.from(json["Recipes"].map((x) => Recipe.fromJson(x)))
            : null,
        ec = json['Ec'] ?? null,
        startDate = json['StartDate'] ?? null,
        cropState = json['CropState'] != null
            ? CropState.fromJson(json['CropState'])
            : null,
        schedules = json['Schedules'] != null ? null : null,
        sensorDeviceId = json['SensorDeviceId'];

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'Company': company == null ? null : company!.toJson(),
        'Cameras':
            cameras != null ? cameras!.map((e) => e.toJson()).toList() : null,
        'Recipes':
            recipes != null ? recipes!.map((e) => e.toJson()).toList() : null,
        'FertigationCrop': true,
        'Ec': ec,
        'StartDate': startDate,
        'CropState': cropState!.toJson(),
        'Schedules': schedules!.map((x) => x.toJson()).toList(),
        'SensorDeviceId': sensorDeviceId,
      };

  @override
  String toString() {
    return "Crop${toJson()}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is Crop &&
      o.name == name &&
      o.id == id &&
      o.company == company &&
      listEquals(o.cameras, cameras) &&
      listEquals(o.recipes, recipes) &&
      o.ec == ec &&
      o.startDate == startDate &&
      o.cropState == cropState &&
      listEquals(o.schedules, schedules) &&
      o.sensorDeviceId == sensorDeviceId;
}

// FIXME(simon): This should be an enum.
class CropState {
  bool vegetative = false;
  bool budding = false;
  bool flowering = false;
  bool ripening = false;
  bool harvested = false;

  CropState._(
      {required this.vegetative,
      required this.budding,
      required this.flowering,
      required this.ripening,
      required this.harvested});

  /// of constructs a CropState from the given string.
  static CropState of(String name) {
    return CropState._(
        vegetative: name == 'Vegetative',
        budding: name == 'Budding',
        flowering: name == 'Flowering',
        ripening: name == 'Ripening',
        harvested: name == 'Harvested');
  }

  CropState.fromJson(Map<String, dynamic> json)
      : vegetative = json['Vegetative'] != null ? json['Vegetative'] : null,
        budding = json['Budding'] ?? null,
        flowering = json['Flowering'] ?? null,
        ripening = json['Ripening'] ?? null,
        harvested = json['Harvested'] ?? null;

  Map<String, dynamic> toJson() => {
        'Vegetative': vegetative,
        'Budding': budding,
        'Flowering': flowering,
        'Ripening': ripening,
        'Harvested': harvested,
      };

  @override
  bool operator ==(dynamic o) =>
      o is CropState &&
      vegetative == o.vegetative &&
      budding == o.budding &&
      flowering == o.flowering &&
      ripening == o.ripening &&
      harvested == o.harvested;
}

class Schedule {
  final String? id;
  final String name;
  final int startDay;
  final List<Task> tasks;

  Schedule(this.id, this.name, this.startDay, this.tasks);

  Schedule copyWith(
      {String? id, String? name, int? startDay, List<Task>? tasks}) {
    return new Schedule(id ?? this.id, name ?? this.name,
        startDay ?? this.startDay, tasks ?? this.tasks);
  }

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

class Repeat {
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;

  Repeat(this.monday, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday);

  Repeat copyWith(
      {bool? monday,
      bool? tuesday,
      bool? wednesday,
      bool? thursday,
      bool? friday,
      bool? saturday,
      bool? sunday}) {
    return Repeat(
        monday ?? this.monday,
        tuesday ?? this.tuesday,
        wednesday ?? this.wednesday,
        thursday ?? this.thursday,
        friday ?? this.friday,
        saturday ?? this.saturday,
        sunday ?? this.sunday);
  }

  Repeat.fromJson(Map<String, dynamic> json)
      : monday = json['Monday'] ?? null,
        tuesday = json['Tuesday'] ?? null,
        wednesday = json['Wednesday'] ?? null,
        thursday = json['Thursday'] ?? null,
        friday = json['Friday'] ?? null,
        saturday = json['Saturday'] ?? null,
        sunday = json['Sunday'] ?? null;

  Map<String, dynamic> toJson() => {
        'Monday': monday,
        'Tuesday': tuesday,
        'Wednesday': wednesday,
        'Thursday': thursday,
        'Friday': friday,
        'Saturday': saturday,
        'Sunday': sunday
      };

  bool operator ==(dynamic o) =>
      o is Repeat &&
      monday == o.monday &&
      tuesday == o.tuesday &&
      wednesday == o.wednesday &&
      thursday == o.thursday &&
      friday == o.friday &&
      saturday == o.saturday &&
      sunday == o.sunday;
}

// FIXME(simon): This should be an enum.
class CropAction {
  bool irrigation;
  bool fertigation;

  CropAction(this.irrigation, this.fertigation);

  static CropAction of(String value) {
    return CropAction(value == 'Irrigation', value == 'Fertigation');
  }

  CropAction.fromJson(Map<String, dynamic> json)
      : irrigation = json['Irrigation'] ?? null,
        fertigation = json['Fertigation'] ?? null;

  Map<String, dynamic> toJson() =>
      {'Irrigation': irrigation, 'Fertigation': fertigation};

  @override
  bool operator ==(dynamic o) =>
      o is CropAction &&
      o.irrigation == irrigation &&
      o.fertigation == fertigation;
}

class ActionRepeat {
  String? id;
  String? cropId;
  Timestamp? time;
  String? action;
  bool? canceled;

  ActionRepeat({this.id, this.cropId, this.time, this.action, this.canceled});

  ActionRepeat.fromJson(Map<String, dynamic> json)
      : id = json['Id'] ?? null,
        cropId = json['CropId'] ?? null,
        time = json['Time'] ?? null,
        canceled = json['Canceled'],
        action = json['Action'] ?? null;

  Map<String, dynamic> toJson() => {
        'Id': id,
        'CropId': cropId,
        'Time': time,
        'Canceled': canceled,
        "Action": action
      };

  @override
  String toString() {
    return "ActionRepeat ${toJson()}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic o) =>
      o is ActionRepeat &&
      o.cropId == cropId &&
      o.id == id &&
      o.time == time &&
      o.action == action &&
      o.canceled == canceled;
}
