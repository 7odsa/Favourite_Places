import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _chosedLocation,
          onTap: (tapPosition, point) {
            _chosedLocation = point;
            setState(() {});
            print(_chosedLocation);
          },
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
                point: _chosedLocation,
                child: Icon(Icons.location_on_rounded, color: Colors.red),
              ),
            ],
          ),
          Align(
            heightFactor: 1,
            child: Text(
              "Pick a Location",
              style: TextTheme.of(context).displaySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
