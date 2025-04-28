import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final placesProvider = NotifierProvider<PlacesNotifier, List<Place>>(
  PlacesNotifier.new,
);

Future<Database> _getDB() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT,lat REAL, lng REAl,address TEXT)",
      );
    },
    version: 1,
  );
  return db;
}

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    loadPlacesFromDB();
    return const [];
  }

  void loadPlacesFromDB() async {
    final db = await _getDB();

    final data = await db.query("user_places");

    final placesList =
        data.map((row) {
          return Place(
            id: row["id"] as String,
            title: row["title"] as String,
            imageFile: File(row["image"] as String),
            locationInformation: LocationInformation(
              location: LatLng(row["lat"] as double, row["lng"] as double),
              areaName: row["address"] as String,
            ),
          );
        }).toList();

    state = placesList;
  }

  void addnewPlace(Place place) async {
    File copiedImage = await saveTheImageInternallyAndReturnThePath(place);

    final newPlace = place.copyWith(newImageFile: copiedImage);

    final db = await _getDB();
    int insertionState = await db.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.imageFile.path,
      "lat": newPlace.locationInformation.location.latitude,
      "lng": newPlace.locationInformation.location.longitude,
      "address": newPlace.locationInformation.areaName,
    });
    print("$insertionState");

    state = [newPlace, ...state];
  }

  Future<File> saveTheImageInternallyAndReturnThePath(Place place) async {
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final imagePath = path.basename(place.imageFile.path);
    final copiedImage = await place.imageFile.copy("${appDir.path}/$imagePath");
    return copiedImage;
  }
}
