import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.placeItem});
  final Place placeItem;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    Widget content =
        (isTapped)
            ? Stack(
              children: [
                MapWidget(
                  pickedLocation: widget.placeItem.locationInformation.location,
                  onTap: (_, _) {
                    isTapped = false;
                    setState(() {});
                  },
                  isSelecting: false,
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Text(
                      "Place Any Where To Go Back",
                      style: TextTheme.of(context).titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
            : Stack(
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: widget.placeItem,
                  child: Image.file(
                    widget.placeItem.imageFilePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 0, 0),
                          const Color.fromARGB(0, 0, 0, 0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          child: MapWidget(
                            pickedLocation:
                                widget.placeItem.locationInformation.location,
                            onTap: (_, _) {
                              isTapped = true;
                              setState(() {});
                            },
                            isSelecting: false,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.placeItem.locationInformation.areaName,
                          style: TextTheme.of(context).titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

    return Scaffold(
      appBar: AppBar(title: Text(widget.placeItem.title)),
      body: content,
    );
  }
}
