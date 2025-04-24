import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placesProvider = NotifierProvider<PlacesNotifier, List<Place>>(
  PlacesNotifier.new,
);

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return const [];
  }

  void addnewPlace(Place place) {
    state = [place, ...state];
  }
}
