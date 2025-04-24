import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/utils.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewScreen extends ConsumerWidget {
  const AddNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    String? _title;
    File? _imageFile;

    void _onSavePressed() {
      if (!_formKey.currentState!.validate() || _imageFile == null) return;
      _formKey.currentState!.save();
      ref
          .read(placesProvider.notifier)
          .addnewPlace(Place(title: _title!, imageFilePath: _imageFile!));
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add New Place")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: white16,
                decoration: InputDecoration(labelText: "Title"),
                maxLines: 1,
                maxLength: 50,
                onSaved: (newValue) {
                  _title = newValue;
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
                  _imageFile = imageFile;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSavePressed,
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
    );
  }
}
