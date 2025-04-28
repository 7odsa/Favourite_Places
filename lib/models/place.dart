import 'dart:io';

import 'package:favorite_places/utils.dart';
import 'package:latlong2/latlong.dart';

class Place {
  Place({
    id,
    required this.title,
    required this.imageFile,
    required this.locationInformation,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File imageFile;
  final LocationInformation locationInformation;

  Place copyWith({
    String? newID,
    String? newTitle,
    File? newImageFile,
    LocationInformation? newLocationInformation,
  }) {
    return Place(
      id: newID ?? id,
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
