import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';
import 'package:plantos/src/models/recipe.dart';

class Crop {
  final String name;
  final String id;
  final Company company;
  final bool selected;
  final List<Camera> cameras;
  final List<Recipe> recipes;
  final bool fertigationCrop;
  final String ec;
  final Timestamp startDate;
  final CropState cropState;
  final Schedule schedule;

  Crop(
      this.name,
      this.id,
      this.company,
      this.cameras,
      this.recipes,
      this.fertigationCrop,
      this.ec,
      this.startDate,
      this.cropState,
      this.schedule,
      this.selected);

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
        schedule = json['Schedule'] != null
            ? Schedule.fromJson(json['Schedule'])
            : null;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'Company': company,
        'Selected': selected,
        'Cameras': cameras,
        'Recipes': recipes,
        'FertigationCrop': fertigationCrop,
        'Ec': ec,
        'StartDate': startDate,
        'CropState': cropState,
        'Schedule': schedule,
      };
}

class CropState {
  final bool vegetative;
  final bool budding;
  final bool flowering;
  final bool ripening;
  final bool harvested;

  CropState(this.vegetative, this.budding, this.flowering, this.ripening,
      this.harvested);

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
  final String time;
  final Repeat repeat;
  final Action action;

  Schedule(this.time, this.action, this.repeat);

  Schedule.fromJson(Map<String, dynamic> json)
      : time = json['Time'] ?? null,
        repeat =
            json['Repeat'] != null ? Repeat.fromJson(json['Repeat']) : null,
        action =
            json['Action'] != null ? Action.fromJson(json['Action']) : null;

  Map<String, dynamic> toJson() => {
        'Time': time,
        'Repeat': repeat,
        'Action': action,
      };
}

class Repeat {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  Repeat(this.monday, this.tuesday, this.wednesday, this.thursday, this.friday,
      this.saturday, this.sunday);

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

class Action {
  final bool irrigation;
  final bool fertigation;

  Action(this.irrigation, this.fertigation);

  Action.fromJson(Map<String, dynamic> json)
      : irrigation = json['Irrigation'] ?? null,
        fertigation = json['Fertigation'] ?? null;

  Map<String, dynamic> toJson() =>
      {'Irrigation': irrigation, 'Fertigation': fertigation};
}
