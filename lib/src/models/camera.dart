import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantos/src/models/company.dart';

import 'company.dart';

class Camera {
  final String id;
  final String description;
  final String cropId;
  final Company company;
  final CollectionReference photos;
  Camera(this.id, this.description, this.cropId, this.company, this.photos);

  Camera.fromJson(Map<String, dynamic> json)
      : id = json['Id'] ?? null,
        company =
            json['Company'] != null ? Company.fromJson(json['Company']) : null,
        description = json['Description'] ?? null,
        cropId = json['CropId'] ?? null,
        photos = json['photos'] ?? null;

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Company': company,
        'Description': description,
        'CropId': cropId,
        'photos': photos,
      };
}
