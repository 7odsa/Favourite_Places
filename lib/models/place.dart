import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({required this.title, required this.imageFilePath}) : id = uuid.v4();

  final String id;
  final String title;
  final File imageFilePath;
}
