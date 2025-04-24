import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/add_new_screen.dart';
import 'package:favorite_places/widgets/places_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Test
      appBar: AppBar(
        title: Text("Great Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddNewScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(
          builder: (context, ref, _) {
            final placesList = ref.watch(placesProvider);
            return (placesList.isNotEmpty)
                ? PlacesListWidget(placesList: placesList)
                : Center(
                  child: Text(
                    "No Places Added Yet",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }
}
