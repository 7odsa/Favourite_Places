// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';
import 'dart:io';

import 'package:favorite_places/widgets/location_map_snapshot.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:favorite_places/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onLocationPicked});

  final void Function(LatLng location, String areaName) onLocationPicked;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _pickedLocation;
  bool isGettingLocation = false;
  bool isThereConnection = false;
  final _mapKey = GlobalKey();
  Future<String?> get _getAreaName async {
    List<geocoding.Placemark>? placemarks;
    if (isThereConnection == true) {
      placemarks = await geocoding.placemarkFromCoordinates(
        52.2165157,
        6.9437819,
      );
      print(placemarks[0].subLocality);
    }
    return placemarks?[0].thoroughfare ?? "";
  }

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

    String? areaName = await _getAreaName;

    setState(() {
      isGettingLocation = false;
      _pickedLocation = LatLng(locationData.latitude!, locationData.longitude!);
      print(_pickedLocation!.latitude);
      print(_pickedLocation!.longitude);
    });

    widget.onLocationPicked(_pickedLocation!, areaName ?? "");

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
          return MapScreen(
            currentLocation: _pickedLocation!,
            isSelecting: true,
          );
        },
      ),
    );
    _pickedLocation =
        (retrievedLocation != null) ? retrievedLocation : _pickedLocation;
    if (!mounted) return;

    String? areaName = await _getAreaName;

    widget.onLocationPicked(_pickedLocation!, areaName ?? "");
    setState(() {});
  }

  // void takeMapSnapShot() async {
  //   try {
  //     await WidgetsBinding.instance.endOfFrame;
  //     RenderRepaintBoundary boundary =
  //         _mapKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     if (boundary.debugNeedsPaint) {
  //       await Future.delayed(Duration(milliseconds: 20));
  //       return takeMapSnapShot();
  //     }
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData = await image.toByteData(
  //       format: ui.ImageByteFormat.png,
  //     );
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //     print('Snapshot taken, bytes length: ${pngBytes.length}');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isGettingLocation == true) {
      content = CircularProgressIndicator();
    } else if (_pickedLocation == null) {
      content = _getText("No Location Chosen Yet.");
    } else if (isThereConnection) {
      content = LocationMapSnapshot(
        // Here We should add key to make the state object know that the widget changed and that it is
        key: ObjectKey(_pickedLocation!),
        pickedLocation: _pickedLocation!,
        isSelecting: false,
      );
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
