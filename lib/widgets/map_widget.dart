// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.pickedLocation,
    this.onTap,
    required this.isSelecting,
    this.onbackToCurrentLocationPressed,
  });

  final LatLng pickedLocation;
  final void Function(TapPosition, LatLng)? onTap;
  final void Function(LatLng)? onbackToCurrentLocationPressed;

  final bool isSelecting;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _chosedLocation;
  late LatLng _initLocation;

  @override
  void initState() {
    super.initState();
    _chosedLocation = widget.pickedLocation;
    _initLocation = widget.pickedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.pickedLocation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        // child: RepaintBoundary(
        //   key: _mapKey,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: _chosedLocation,
            initialZoom: 15,
            onTap: (tapPosition, point) {
              if (widget.isSelecting) {
                _chosedLocation = point;
                setState(() {});
              }
              if (widget.onTap != null) widget.onTap!(tapPosition, point);
            },
            interactionOptions: InteractionOptions(
              flags:
                  widget.isSelecting
                      ? InteractiveFlag.all
                      : InteractiveFlag.none,
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
            MarkerLayer(
              rotate: true,
              markers: [
                Marker(
                  point: _chosedLocation,
                  child: const Icon(
                    Icons.location_on,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            // :
            // I decided to not use a marker because the marker has on click and change it's location
            // whenever i clicked on the map and i wanna this map to be for previewing only
            // and not for interacting with so instead i chosed to use a regular icon and center it
            // Align(
            //   alignment: Alignment.center,
            //   child: const Icon(
            //     Icons.location_on,
            //     size: 35,
            //     color: Colors.blue,
            //   ),
            // ),
            if (widget.isSelecting)
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
                    elevation: WidgetStatePropertyAll(12),
                  ),
                  onPressed: () {
                    _chosedLocation = _initLocation;
                    if (widget.onbackToCurrentLocationPressed != null) {
                      widget.onbackToCurrentLocationPressed!(_chosedLocation);
                    }
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
}
