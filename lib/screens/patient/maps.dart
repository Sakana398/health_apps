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
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mental Health Clinic Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(3.1319, 101.640), // Center the map initially
          zoom: 12,               // Default zoom level
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
