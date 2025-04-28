import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:path/path.dart' as path;

final placesProvider = NotifierProvider<PlacesNotifier, List<Place>>(
  PlacesNotifier.new,
);

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return const [];
  }

  void addnewPlace(Place place) async {
    File copiedImage = await saveTheImageInternallyAndReturnThePath(place);

    final newPlace = place.copyWith(newImageFile: copiedImage);

    state = [newPlace, ...state];
  }

  Future<File> saveTheImageInternallyAndReturnThePath(Place place) async {
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final imagePath = path.basename(place.imageFile.path);
    final copiedImage = await place.imageFile.copy("${appDir.path}/$imagePath");
    return copiedImage;
  }
}
