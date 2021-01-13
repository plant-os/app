import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/recipe.dart';

class Crop {
  String name;
  String id;
  Company company;
  bool selected;
  List<Camera> cameras;
  List<Recipe> recipes;
  bool fertigationCrop;
  String ec;
  Timestamp startDate;
  CropState cropState;
  List<Schedule> schedules;

  Crop(
      {this.name,
      this.id,
      this.company,
      this.cameras,
      this.recipes,
      this.ec,
      this.startDate,
      this.cropState,
      this.schedules,
      this.selected});

  // Return a new Crop with the given fields overwritten.
  Crop withValues(
      {String name,
      String id,
      Company company,
      List<Camera> cameras,
      List<Recipe> recipes,
      String ec,
      Timestamp startDate,
      CropState cropState,
      List<Schedule> schedules,
      bool selected}) {
    return Crop(
        company: company ?? this.company,
        id: id ?? this.id,
        name: name ?? this.name,
        ec: ec ?? this.ec,
        startDate: startDate ?? this.startDate,
        cropState: cropState ?? this.cropState,
        schedules: schedules ?? this.schedules,
        selected: selected ?? this.selected);
  }

  Crop.fromJson(Map<String, dynamic> json)
      : name = json['Name'] ?? null,
        id = json['Id'] ?? null,
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        selected = json['Selected'],
        cameras = json['Cameras'] != null
            ? List<Camera>.from(json["Cameras"].map((x) => Camera.fromJson(x)))
            : null,
        recipes = json['Recipes'] != null
            ? List<Recipe>.from(json["Recipes"].map((x) => Recipe.fromJson(x)))
            : null,
        fertigationCrop = json['FertigationCrop'] ?? null,
        ec = json['Ec'] ?? null,
        startDate = json['StartDate'] ?? null,
        cropState = json['CropState'] != null
            ? CropState.fromJson(json['CropState'])
            : null,
        schedules = json['Schedules'] != null
            ? List<Schedule>.from(
                json["Schedules"].map((x) => Schedule.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'Company': company.toJson(),
        'Selected': selected,
        'Cameras':
            cameras != null ? cameras.map((e) => e.toJson()).toList() : null,
        'Recipes':
            recipes != null ? recipes.map((e) => e.toJson()).toList() : null,
        'FertigationCrop': true,
        'Ec': ec,
        'StartDate': startDate,
        'CropState': cropState.toJson(),
        'Schedules': schedules.map((x) => x.toJson()).toList()
      };

  @override
  String toString() {
    return "Crop{${toJson()}}";
  }

  // ignore: hash_and_equals
  @override
  bool operator ==(dynamic other) {
    if (!(other is Crop)) {
      return false;
    }

    return other.name == name &&
        other.id == id &&
        other.company == company &&
        other.selected == selected &&
        other.cameras == cameras &&
        other.recipes == recipes &&
        other.ec == ec &&
        other.startDate == startDate &&
        other.cropState == cropState &&
        other.schedules == schedules;
  }
}

// FIXME(simon): This should be an enum.
class CropState {
  bool vegetative;
  bool budding;
  bool flowering;
  bool ripening;
  bool harvested;

  CropState(
      {this.vegetative,
      this.budding,
      this.flowering,
      this.ripening,
      this.harvested});

  /// of constructs a CropState from the given string.
  static CropState of(String name) {
    return CropState(
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
}

class Schedule {
  Timestamp time;
  Repeat repeat;
  CropAction action;

  Schedule(this.time, this.action, this.repeat);

  Schedule copyWith({Timestamp time, CropAction action, Repeat repeat}) {
    return new Schedule(
        time ?? this.time, action ?? this.action, repeat ?? this.repeat);
  }

  Schedule.fromJson(Map<String, dynamic> json)
      : time = json['Time'] ?? null,
        repeat =
            json['Repeat'] != null ? Repeat.fromJson(json['Repeat']) : null,
        action =
            json['Action'] != null ? CropAction.fromJson(json['Action']) : null;

  Map<String, dynamic> toJson() => {
        'Time': time,
        'Repeat': repeat.toJson(),
        'Action': action.toJson(),
      };

  @override
  String toString() => "Schedule{time=$time, action=$action, repeat=$repeat}";
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
      {bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday}) {
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
}

class ActionRepeat {
  String id;
  String cropId;
  Timestamp time;
  String action;
  bool canceled;

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
  bool operator ==(dynamic other) {
    if (!(other is ActionRepeat)) {
      return false;
    }

    return other.cropId == cropId &&
        other.id == id &&
        other.time == time &&
        other.action == action &&
        other.canceled == canceled;
  }
}
