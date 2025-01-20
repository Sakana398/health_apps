import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(0, 0); // Default center of the map

  // Method to handle map creation and fetch markers from assets location.json
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    // Load the location data from assets/location.json
    final String response = await rootBundle.loadString('assets/location.json');
    final data = json.decode(response);

    setState(() {
      _markers.clear();
      // Loop through the clinics data and create markers
      for (var clinic in data['clinics']) {
        final marker = Marker(
          markerId: MarkerId(clinic['name']),
          position: LatLng(clinic['lat'], clinic['lng']),
          infoWindow: InfoWindow(
            title: clinic['name'],
            snippet: clinic['address'],
          ),
        );
        _markers[clinic['name']] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Clinics Locations'),
        elevation: 2,
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Center the map initially
          zoom: 2,               // Default zoom level
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
