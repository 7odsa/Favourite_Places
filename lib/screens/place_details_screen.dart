import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.placeItem});
  final Place placeItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(placeItem.title)),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: placeItem,
            child: Image.file(
              placeItem.imageFilePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
