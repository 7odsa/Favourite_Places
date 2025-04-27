// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapSnapshot extends StatelessWidget {
  const LocationMapSnapshot({
    super.key,
    required this.pickedLocation,
    this.onTap,
  });

  final LatLng pickedLocation;
  final void Function(TapPosition, LatLng)? onTap;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pickedLocation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        // child: RepaintBoundary(
        //   key: _mapKey,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: pickedLocation,
            initialZoom: 15,
            onTap: onTap,
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
              alignment: Alignment.topCenter,
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
}
