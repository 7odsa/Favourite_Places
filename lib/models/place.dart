import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.imageFile,
    required this.locationInformation,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File imageFile;
  final LocationInformation locationInformation;

  Place copyWith({
    String? newTitle,
    File? newImageFile,
    LocationInformation? newLocationInformation,
  }) {
    return Place(
      title: newTitle ?? title,
      imageFile: newImageFile ?? imageFile,
      locationInformation: newLocationInformation ??= locationInformation,
    );
  }
}

class LocationInformation {
  final LatLng location;
  final String areaName;

  LocationInformation({required this.location, required this.areaName});
}
