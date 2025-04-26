import 'dart:io';

import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationPicked});

  final void Function(LatLng location) onLocationPicked;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _pickedLocation;
  bool isGettingLocation = false;
  bool isThereConnection = false;

  Future<void> _checkInternetConnection([
    void Function()? callingFunction,
  ]) async {
    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');

      setState(() {
        isThereConnection = false;
      });
      _showDialog(
        title: "No Internet Connection",
        content:
            "Your current location saved. \nBut can't show the Map, Due to connection Lost.",
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              callingFunction?.call();
            },
            child: Text("Try Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
          ),
        ],
      );
      // AlertDialog(
      //   title: Text(),
      //   content: Text(),
      // );
      return;
    }

    setState(() {
      isThereConnection = true;
    });
  }

  void _showDialog({String? title, String? content, List<Widget>? actions}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title ?? ""),
          content: SingleChildScrollView(
            child: ListBody(children: [Text(content ?? "")]),
          ),
          actions: actions ?? [],
        );
      },
    );
  }

  void _getCurrentLocation([void Function()? onLocationRetrieved]) async {
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

    // if (isThereConnection == true) {
    //   List<geocoding.Placemark> placemarks = await geocoding
    //       .placemarkFromCoordinates(52.2165157, 6.9437819);
    //   print(placemarks[0].subLocality);
    // }

    setState(() {
      isGettingLocation = false;
      _pickedLocation = LatLng(locationData.latitude!, locationData.longitude!);
      print(_pickedLocation!.latitude);
      print(_pickedLocation!.longitude);
    });

    widget.onLocationPicked(_pickedLocation!);

    if (onLocationRetrieved != null) onLocationRetrieved();
  }

  void onGetCurrentLocatiomnPressed() async {
    await _checkInternetConnection(onGetCurrentLocatiomnPressed);
    _getCurrentLocation();
  }

  void onPickLocationPressed() async {
    await _checkInternetConnection(onPickLocationPressed);
    if (!isThereConnection || isGettingLocation) return;

    if (_pickedLocation == null) {
      _getCurrentLocation(onPickLocationPressed);
      return;
    }

    if (!mounted) return;

    LatLng? retrievedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return MapScreen(currentLocation: _pickedLocation!);
        },
      ),
    );
    _pickedLocation =
        (retrievedLocation != null) ? retrievedLocation : _pickedLocation;
    if (!mounted) return;
    widget.onLocationPicked(_pickedLocation!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isGettingLocation == true) {
      content = CircularProgressIndicator();
    } else if (_pickedLocation == null) {
      content = _getText("No Location Chosen Yet.");
    } else if (isThereConnection) {
      content = _getLocationMap();
    } else {
      content = _getText("No Internet Connection");
    }

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
              onPressed: onGetCurrentLocatiomnPressed,
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

  Widget _getLocationMap() {
    return Hero(
      tag: _pickedLocation!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: _pickedLocation!,
            initialZoom: 15,
            // onTap: _onMapTapped,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
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
            //       child: const Icon(
            //         Icons.location_on,
            //         size: 35,
            //         color: Colors.blue,
            //       ),
            //     ),
            //   ],
            // ),

            // I decided to not use a marker because the marker has on click and change it's location
            // whenever i clicked on the map and i wanna this map to be for previewing only
            // and not for interacting with so instead i chosed to use a regular icon and center it
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
      ),
    );
  }

  Widget _getText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextTheme.of(
        context,
      ).bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  // void _onMapTapped(TapPosition tapPosition, LatLng point) {
  //   _pickedLocation = point;
  //   print(_pickedLocation);
  //   setState(() {});
  // }
}
