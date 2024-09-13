import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  Location _locationController = Location();
  LatLng? _currentP;
  GoogleMapController? _mapController; // Map controller
  static const String _locationText = "Find Your Restaurant"; // Static text for AppBar

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( // Make it a constant Text widget to prevent updates
          _locationText,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: const Color(0xFFF86A2E),
        iconTheme: const IconThemeData(color: Colors.white), // Optional: Set icon color to white
      ),
      body: Container(
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange bar
              Colors.white, // White
            ],
          ),
        ),
        child: Center(
          child: _currentP == null
              ? const Center(child: Text("Loading...")) // Show a loading message until the current location is obtained
              : Container(
                  height: 550, // Set the height for the map container
                  width: 500, // Set the width for the map container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Optional rounded corners
                  ),
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      // Move the camera to the current location when the map is created
                      _moveCamera(_currentP!);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentP!, // Use the current location as the initial position
                      zoom: 13,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                        position: _currentP!,
                      ),
                    },
                  ),
                ),
        ),
      ),
    );
  }

  // Fetch location updates
  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if service is enabled
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check for permission
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Listen to location changes
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          // Update the current location without changing the AppBar text
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentP); // Log the current coordinates
          // Move the camera to the current location
          if (_mapController != null) {
            _moveCamera(_currentP!);
          }
        });
      }
    });
  }

  // Move the camera to the provided location
  Future<void> _moveCamera(LatLng position) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 14,
        ),
      ));
    }
  }
}
