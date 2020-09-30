import 'package:plantos/src/models/camera.dart';
import 'package:plantos/src/models/company.dart';

class Crop {
  final String name;
  final String id;
  final Company company;
  final bool selected;
  final List<Camera> cameras;
  final List<String> recipes;
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
        company = json['Company'],
        selected = json['Selected'],
        cameras = json['Cameras'],
        recipes = json['Recipes'],
        fertigationCrop = json['FertigationCrop'],
        ec = json['Ec'],
        startDate = json['StartDate'],
        state = json['State'],
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
}

class Schedule {}
