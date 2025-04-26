import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.imageFilePath,
    required this.location,
    required this.areaName,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File imageFilePath;
  final LatLng location;
  final String areaName;
}
