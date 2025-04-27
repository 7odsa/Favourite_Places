import 'package:favorite_places/widgets/map_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.currentLocation,
    this.isSelecting = false,
    this.onTap,
  });
  final LatLng currentLocation;
  final bool isSelecting;
  final void Function(TapPosition, LatLng)? onTap;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _chosedLocation;
  @override
  void initState() {
    super.initState();
    _chosedLocation = widget.currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onBackButtonPressed,
          ),
          centerTitle: true,
          title: Text(widget.isSelecting ? "Pick a Location" : "Your Location"),
        ),
        body: MapWidget(
          pickedLocation: _chosedLocation,
          isSelecting: true,
          onTap: _onMapTapped,
          onbackToCurrentLocationPressed: (newPoint) {
            _chosedLocation = newPoint;
          },
        ),
      ),
    );
  }

  void onBackButtonPressed() {
    LatLng sendBackLocation = widget.currentLocation;
    if (_chosedLocation != widget.currentLocation) {
      sendBackLocation = _chosedLocation;
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Chose this location'),

            actions: [
              TextButton(
                child: const Text('Stay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Stick on original Location'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onPickedLocation(widget.currentLocation);
                },
              ),
              TextButton(
                child: Text(
                  'Yep!',
                  style: TextTheme.of(context).titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onPickedLocation(sendBackLocation);
                },
              ),
            ],
          );
        },
      );
    } else {
      _onPickedLocation(sendBackLocation);
    }
  }

  void _onMapTapped(TapPosition tapPosition, LatLng point) async {
    _chosedLocation = point;

    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //   _chosedLocation.latitude,
    //   _chosedLocation.longitude,
    // );

    // String areaName = placemarks[0].locality!;
    // String streetName = placemarks[0].thoroughfare!;
    // String additionalInfo = placemarks[0].street!;

    // print(placemarks[0].locality!);
    // print(placemarks[0].administrativeArea!);
    // print(placemarks[0].street!);
    // print(placemarks[0].thoroughfare!);

    // if (!mounted) return;

    // await showDialog<void>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    //     return CupertinoAlertDialog(
    //       title: const Text('Wanna Pick this Location?'),
    //       // content: SingleChildScrollView(
    //       //   child: ListBody(children: [Text('At: \n$areaName\n$streetName')]),
    //       // ),
    //       actions: [
    //         TextButton(
    //           child: const Text('No'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: Text(
    //             'Yep!',
    //             style: TextTheme.of(context).titleMedium!.copyWith(
    //               color: Theme.of(context).colorScheme.onSurface,
    //             ),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             _onPickedLocation(_chosedLocation);
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );

    // setState(() {});
    // print(_chosedLocation);
  }

  void _onPickedLocation(LatLng location) {
    if (mounted) Navigator.of(context).pop(location);
  }
}
