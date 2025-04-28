import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/utils.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class AddNewScreen extends ConsumerWidget {
  const AddNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    String? title;
    File? imageFile;
    LatLng? location;
    String? areaName;

    void onSavePressed() {
      if (!formKey.currentState!.validate() ||
          imageFile == null ||
          location == null) {
        return;
      }
      formKey.currentState!.save();

      ref
          .read(placesProvider.notifier)
          .addnewPlace(
            Place(
              title: title!,
              imageFile: imageFile,
              locationInformation: LocationInformation(
                location: location,
                areaName: areaName ?? "",
              ),
            ),
          );
      Navigator.of(context).pop();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Add New Place")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  style: white16,
                  decoration: InputDecoration(labelText: "Title"),
                  maxLines: 1,
                  maxLength: 50,
                  onSaved: (newValue) {
                    title = newValue;
                  },
                  validator: (value) {
                    // TODO
                    if (value == null || value.isEmpty) return "a7a";
                    return null;
                  },
                ),
                SizedBox(height: 8),
                ImageInput(
                  onImagePicked: (imageFile) {
                    imageFile = imageFile;
                  },
                ),
                SizedBox(height: 8),
                LocationInput(
                  onLocationPicked: (location, areaName) {
                    location = location;
                    areaName = areaName;
                    print(location);
                    print(areaName);
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onSavePressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text("Add Place"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
