import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package; // Alias location package
import 'package:geocoding/geocoding.dart'; // Import geocoding package for converting address to coordinates

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  // Use the alias for the location package
  location_package.Location _locationController = location_package.Location();
  LatLng? _currentP;
  LatLng? _searchedLocation; // For storing the searched location
  GoogleMapController? _mapController; // Map controller
  TextEditingController _searchController = TextEditingController(); // Controller for search input
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
        child: Stack(
          children: [
            _currentP == null
                ? const Center(child: Text("Loading...")) // Show a loading message until the current location is obtained
                : Container(
                    height: double.infinity, // Set the height for the map container
                    width: double.infinity, // Make map fill the width
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
                        if (_searchedLocation != null) // Add marker for searched location
                          Marker(
                            markerId: const MarkerId("_searchedLocation"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed,
                            ),
                            position: _searchedLocation!,
                          ),
                      },
                    ),
                  ),

            // Search bar overlay
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search location...",
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    // Perform search on submit
                    _searchPlace(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fetch location updates
  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    location_package.PermissionStatus _permissionGranted;

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
    if (_permissionGranted == location_package.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != location_package.PermissionStatus.granted) {
        return;
      }
    }

    // Listen to location changes
    _locationController.onLocationChanged.listen((location_package.LocationData currentLocation) {
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

  // Handle location search and move the camera to the searched location
  Future<void> _searchPlace(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query); // Use geocoding to get coordinates
      if (locations.isNotEmpty) {
        final newPosition = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _searchedLocation = newPosition; // Store the searched location
        });
        _moveCamera(newPosition); // Move the map camera to the searched location
        print("Searched location: $_searchedLocation");
      }
    } catch (e) {
      print("Error occurred while searching for the location: $e");
    }
  }
}
