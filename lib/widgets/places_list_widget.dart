import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlacesListWidget extends StatelessWidget {
  const PlacesListWidget({super.key, required this.placesList});
  final List<Place> placesList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 8);
      },
      itemCount: placesList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Hero(
            tag: placesList[index],
            child: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(placesList[index].imageFilePath),
            ),
          ),
          title: Text(
            placesList[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(placesList[index].areaName),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return PlaceDetailsScreen(placeItem: placesList[index]);
                },
              ),
            );
          },
        );
      },
    );
  }
}
