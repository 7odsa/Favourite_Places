import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImagePicked});

  final void Function(File imageFile) onImagePicked;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imgaePicker = ImagePicker();
    final pickedImage = await imgaePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onImagePicked(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {
        _takePicture();
      },
      icon: Icon(Icons.camera),
      label: Text("Take Picture"),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () {
          _takePicture();
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: content,
      ),
    );
  }
}
