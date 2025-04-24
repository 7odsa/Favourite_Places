import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No Location Chosen Yet.",
      textAlign: TextAlign.center,
      style: TextTheme.of(
        context,
      ).bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.location_on, size: 24),
              onPressed: () {},
              label: Text("Get current Location"),
            ),
            Text(
              "OR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.map, size: 24),
              onPressed: () {},
              label: Text("Pick a Location"),
            ),
          ],
        ),
      ],
    );
  }
}
