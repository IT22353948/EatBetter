import 'dart:convert'; // For decoding the HTTP response
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart'; // Import for geocoding
import 'package:http/http.dart' as http; // Import for making API requests
import '../home.dart'; // Import your Home page

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final location_package.Location _locationController = location_package.Location();
  LatLng? _currentP; // Current location
  LatLng? _searchedLocation; // Searched location
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController(); // Controller for search input
  final Set<Marker> _markers = {}; // Markers for map
  static const String _locationText = "Find Your Restaurant";

  //  Google Places API key
  final String _placesApiKey = "AIzaSyCIOwQeu3gc7WmTqb_aqnznqufJalwZ_s4";

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding for a circular icon
          child: IconButton(
            icon: Container(
              width: 45, // Larger width for the circle
              height: 45, // Larger height for the circle
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Background color for the circle
              ),
              child: const Icon(
                Icons.arrow_back, // Back arrow icon
                color: Color(0xFFF86A2E), // Color for the arrow
                size: 24, // Adjust the size of the arrow if needed
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()), // Navigate to the home page
              );
            },
          ),
        ),
        title: const Text(
          _locationText,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF86A2E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
                      markers: _markers, // Set all markers, including restaurants
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

    // Listen for location changes
    _locationController.onLocationChanged.listen((location_package.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);

          // Add a marker for the current location
          _markers.add(
            Marker(
              markerId: const MarkerId("current_location"),  // Unique ID for the current location marker
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Customize color to blue
              position: _currentP!,  // Current location coordinates
              infoWindow: const InfoWindow(title: "Your Location"),  // Optional: Title for the marker
            ),
          );

          // Move the camera to the current location
          _moveCamera(_currentP!);

          // Fetch nearby restaurants after current location is set
          _fetchNearbyRestaurants();
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
          
          // Ensure unique MarkerId for each searched location
          final searchMarkerId = MarkerId("searched_location_${DateTime.now().millisecondsSinceEpoch}");
          
          _markers.add(
            Marker(
              markerId: searchMarkerId,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              position: _searchedLocation!,
              infoWindow: InfoWindow(title: "Searched Location"), // Optional: Add an info window for the marker
            ),
          );
        });
        _moveCamera(newPosition); // Move the camera to the searched location

        // After moving to the searched location, fetch nearby restaurants for that area
        await _fetchNearbyRestaurants();
      }
    } catch (e) {
      print("Error occurred while searching for the location: $e");
    }
  }

  // Fetch nearby restaurants using Google Places API
  Future<void> _fetchNearbyRestaurants() async {
    if (_currentP == null && _searchedLocation == null) return;

    LatLng searchLocation = _searchedLocation ?? _currentP!; // Use searched location if available, otherwise current location
    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${searchLocation.latitude},${searchLocation.longitude}'
        '&radius=5000' // 5 km radius
        '&type=restaurant' // Only fetch restaurants
        '&key=$_placesApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Debugging: Print out the status and the result count
        print('Status: ${data["status"]}');
        print('Results count: ${data["results"].length}');

        if (data['results'].isNotEmpty) {
          setState(() {
            // Clear any existing restaurant markers before adding new ones
            _markers.removeWhere((marker) => marker.markerId.value.contains("restaurant"));

            // Add a marker for each restaurant
            for (var result in data['results']) {
              final placeLocation = LatLng(
                result['geometry']['location']['lat'],
                result['geometry']['location']['lng'],
              );
              
              _markers.add(
                Marker(
                  markerId: MarkerId("restaurant_${result['place_id']}"),
                  position: placeLocation,
                  infoWindow: InfoWindow(
                    title: result['name'],
                    snippet: result['vicinity'],
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Customize marker color for restaurants
                ),
              );
            }
          });
        } else {
          // Handle case when no results are found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No restaurants found near the location.')),
          );
        }
      } else {
        print('Failed to fetch restaurants. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching restaurants: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
