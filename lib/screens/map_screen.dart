import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.currentLocation});
  final LatLng currentLocation;

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
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: _chosedLocation,
        child: FlutterMap(
          options: MapOptions(
            initialZoom: 15,
            initialCenter: _chosedLocation,
            onTap: _onMapTapped,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.google.com/vt/lyrs=m&hl={hl}&x={x}&y={y}&z={z}',
              additionalOptions: const {'hl': 'ar'},
              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  rotate: true,
                  point: _chosedLocation,
                  child: const Icon(
                    Icons.location_on,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Align(
              heightFactor: 1,
              child: Text(
                "Pick a Location",
                style: TextTheme.of(
                  context,
                ).displaySmall!.copyWith(color: Colors.blue),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
                  elevation: WidgetStatePropertyAll(12),
                ),
                onPressed: () {
                  _chosedLocation = widget.currentLocation;
                  setState(() {});
                },
                icon: Icon(
                  Icons.location_history,
                  color: Colors.blue,
                  size: 24,
                ),
                label: Text(
                  "Back to Your current location",
                  style: TextTheme.of(
                    context,
                  ).bodyLarge!.copyWith(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapTapped(tapPosition, point) async {
    _chosedLocation = point;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _chosedLocation.latitude,
      _chosedLocation.longitude,
    );

    String areaName = placemarks[0].locality!;

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Wanna Pick this Location?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [Text('At area: \n${areaName}'), Text(' ')],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
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
                _onPickedLocation();
              },
            ),
          ],
        );
      },
    );

    setState(() {});
    print(_chosedLocation);
  }

  void _onPickedLocation() {
    Navigator.of(context).pop(_chosedLocation);
  }
}
