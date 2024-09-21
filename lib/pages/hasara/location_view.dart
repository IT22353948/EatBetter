import 'dart:convert'; // For decoding the HTTP response
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart'; // Import for geocoding
import 'package:http/http.dart' as http; // Import for making API requests
<<<<<<<<< Temporary merge branch 1
import '../home.dart'; // Import your Home page
=========
>>>>>>>>> Temporary merge branch 2

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

<<<<<<<<< Temporary merge branch 1
  //  Google Places API key
  final String _placesApiKey = "AIzaSyCIOwQeu3gc7WmTqb_aqnznqufJalwZ_s4";
=========
  // Google Places API key
  final String _placesApiKey = "AIzaSyCIOwQeu3gc7WmTqb_aqnznqufJalwZ_s4";

  // List to hold nearby restaurant data
  List<dynamic> _restaurants = [];

  // State variables for the bottom sheet
  bool _isSheetExpanded = false;
  double _currentSheetSize = 0.25; // Adjust initial size as needed
>>>>>>>>> Temporary merge branch 2

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          _locationText,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF86A2E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _currentP == null
              ? const Center(child: Text("Loading...")) // Show loading message
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

          // Add the arrow button for toggling the restaurant view
          Positioned(
            bottom: 100, // Position above the bottom sheet
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: GestureDetector(
              onTap: _toggleBottomSheet,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSheetExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),

          // DraggableScrollableSheet for restaurant details
          DraggableScrollableSheet(
            initialChildSize: _currentSheetSize,
            minChildSize: 0.25,
            maxChildSize: 0.35,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: _restaurants.isEmpty
                    ? const Center(child: Text('No restaurants found'))
                    : ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,  // Set scroll direction to horizontal
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _restaurants[index];
                          String photoReference = restaurant['photos'] != null
                              ? restaurant['photos'][0]['photo_reference']
                              : ''; // Get photo reference if available

                          // Restaurant photo URL using photo reference
                          String photoUrl = photoReference.isNotEmpty
                              ? 'https://maps.googleapis.com/maps/api/place/photo'
                                '?maxwidth=400'
                                '&photoreference=$photoReference'
                                '&key=$_placesApiKey'
                              : 'https://via.placeholder.com/400'; // Placeholder image if no photo available

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Rounded corners for the card
                            ),
                            color: const Color(0xFFF86A2E).withOpacity(0.85), // Orange mix background color
                            child: SizedBox(
                              width: 320,// Card width
                              height: 150, // Card height
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Restaurant image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      photoUrl,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover, // Cover the image space
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant['name'] ?? 'Unknown Name',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white, // White text on orange background
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Rating: ${restaurant['rating'] ?? 'No rating'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(179, 251, 226, 226),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          restaurant['vicinity'] ?? 'No address provided',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
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
      }
    } catch (e) {
      print("Error occurred while searching for the location: $e");
    }
  }

  // Fetch nearby restaurants using Google Places API
  Future<void> _fetchNearbyRestaurants() async {
    if (_currentP == null) return;

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentP!.latitude},${_currentP!.longitude}'
        '&radius=5000' // 5 km radius
        '&type=restaurant' // Only fetch restaurants
        '&key=$_placesApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          List<dynamic> results = data['results'];
          Set<Marker> restaurantMarkers = results.map((restaurant) {
            final LatLng position = LatLng(
              restaurant['geometry']['location']['lat'],
              restaurant['geometry']['location']['lng'],
            );
            return Marker(
              markerId: MarkerId(restaurant['place_id']),
              position: position,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: restaurant['name']),
            );
          }).toSet();

          setState(() {
            _restaurants = results; // Update the list of restaurants
            _markers.addAll(restaurantMarkers);
          });
        }
      } else {
        print("Failed to fetch nearby restaurants: ${response.body}");
      }
    } catch (e) {
      print("Error fetching nearby restaurants: $e");
    }
  }

  // Toggle the bottom sheet visibility
  void _toggleBottomSheet() {
    setState(() {
      _isSheetExpanded = !_isSheetExpanded;
      _currentSheetSize = _isSheetExpanded ? 0.35 : 0.25; // Adjust size as needed
    });
  }
}
