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
  final DateTime startDate;
  final State state;
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
      this.state,
      this.schedule,
      this.selected);

  Crop.fromJson(Map<String, dynamic> json)
      : name = json['Name'],
        id = json['Id'],
        company = Company.fromJson(json['Company']),
        selected = json['Selected'],
        cameras =
            List<Camera>.from(json["Cameras"].map((x) => Camera.fromJson(x))),
        recipes =
            List<Recipe>.from(json["Recipes"].map((x) => Recipe.fromJson(x))),
        fertigationCrop = json['FertigationCrop'],
        ec = json['Ec'],
        startDate = json['StartDate'],
        state = State.fromJson(json['State']),
        schedule = json['Schedule'];

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
        'State': state,
        'Schedule': schedule,
      };
}

class State {
  final bool vegetative;
  final bool budding;
  final bool flowering;
  final bool ripening;
  final bool harvested;

  State(this.vegetative, this.budding, this.flowering, this.ripening,
      this.harvested);
  State.fromJson(Map<String, dynamic> json)
      : vegetative = json['Vegetative'],
        budding = json['Budding'],
        flowering = json['Flowering'],
        ripening = json['Ripening'],
        harvested = json['Harvested'];
}

class Schedule {}
