import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _pickedLocation;
  bool isGettingLocation = false;

  void _getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(52.2165157, 6.9437819);
    print(placemarks[0].street);
    setState(() {
      isGettingLocation = false;
      _pickedLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget content =
        isGettingLocation == true
            ? CircularProgressIndicator()
            : (_pickedLocation == null)
            ? Text(
              "No Location Chosen Yet.",
              textAlign: TextAlign.center,
              style: TextTheme.of(context).bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
            : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _pickedLocation!,
                  initialZoom: 15,
                  onTap: _onMapTapped,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.google.com/vt/lyrs=m&hl={hl}&x={x}&y={y}&z={z}',
                    additionalOptions: const {'hl': 'ar'},

                    userAgentPackageName: 'com..app',
                    subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                  ),
                  // MarkerLayer(
                  //   markers: [
                  //     Marker(
                  //       point: _pickedLocation!,
                  //       child: Icon(Icons.location_on),
                  //     ),
                  //   ],
                  // ),
                  Align(
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.location_on,
                      size: 35,
                      color: Colors.blue,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.35),
                    child: Text(
                      "Your current Location",
                      style: TextTheme.of(context).titleMedium!.copyWith(
                        color: const Color.fromARGB(255, 0, 108, 197),
                      ),
                    ),
                  ),
                ],
              ),
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
              onPressed: () {
                _getCurrentLocation();
              },
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
              onPressed: onPickLocationPressed,
              label: Text("Pick a Location"),
            ),
          ],
        ),
      ],
    );
  }

  void _onMapTapped(TapPosition tapPosition, LatLng point) {
    _pickedLocation = point;
    setState(() {});
  }

  void onPickLocationPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MapScreen(currentLocation: _pickedLocation!);
        },
      ),
    );
  }
}
