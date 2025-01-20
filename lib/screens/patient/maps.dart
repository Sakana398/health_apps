import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_apps/model/locations.dart' as locations;

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  final LatLng _center = const LatLng(0, 0); // Default center of the map

  // Method to handle map creation and fetch markers
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final googleOffices = await locations.getGoogleOffices();

    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Office Locations'),
        elevation: 2,
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Center the map initially
          zoom: 2,             // Default zoom level
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
