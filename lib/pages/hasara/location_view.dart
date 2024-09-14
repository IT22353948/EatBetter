import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart'; // Import for geocoding

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  location_package.Location _locationController = location_package.Location();
  LatLng? _currentP; // Current location
  LatLng? _searchedLocation; // Searched location
  GoogleMapController? _mapController;
  TextEditingController _searchController = TextEditingController(); // Controller for search input
  static const String _locationText = "Find Your Restaurant";

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( // Constant AppBar title
          _locationText,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF86A2E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange
              Colors.white, // White
            ],
          ),
        ),
        child: Stack(
          children: [
            _currentP == null
                ? const Center(child: Text("Loading...")) // Show a loading message while fetching the location
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                    ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        _moveCamera(_currentP!);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentP!,
                        zoom: 13,
                      ),
                      markers: {
                        // Marker for the current location
                        Marker(
                          markerId: const MarkerId("_currentLocation"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue,
                          ),
                          position: _currentP!,
                        ),
                        // Marker for the searched location, if available
                        if (_searchedLocation != null)
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

            // Search bar overlay at the top
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
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
                    _searchPlace(value); // Search and mark location
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

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == location_package.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != location_package.PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((location_package.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _moveCamera(_currentP!);
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

  // Search for a location and update the marker
  Future<void> _searchPlace(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query); // Geocode the search query
      if (locations.isNotEmpty) {
        final newPosition = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _searchedLocation = newPosition; // Set the searched location
        });
        _moveCamera(newPosition); // Move the camera to the searched location
      }
    } catch (e) {
      print("Error occurred while searching for the location: $e");
    }
  }
}
