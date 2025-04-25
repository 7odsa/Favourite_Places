import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _LocationDim = LatLng(50, 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _LocationDim,
          onTap: (tapPosition, point) {
            _LocationDim = point;
            print(_LocationDim);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.google.com/vt/lyrs=m&hl={hl}&x={x}&y={y}&z={z}',
            additionalOptions: const {'hl': 'ar'},
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
        ],
      ),
    );
  }
}
