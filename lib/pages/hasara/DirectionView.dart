import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:http/http.dart' as http;

class DirectionView extends StatefulWidget {
  final LatLng destination; // Destination (restaurant) location
  final String restaurantName; // Add restaurant name parameter


  const DirectionView({
    required this.destination,
    required this.restaurantName,
    super.key});

  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
  final location_package.Location _locationController = location_package.Location();
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  List<LatLng> _routeCoordinates = []; // Stores the polyline coordinates for the route
  Set<Polyline> _polylines = {}; // Store the route polylines
  final String _directionsApiKey = "AIzaSyCIOwQeu3gc7WmTqb_aqnznqufJalwZ_s4"; 
  Set<Marker> _markers = {}; 

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
    _addRestaurantMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Destination",
         style: TextStyle(
         color: Colors.white, // Set text color to white 
       ),
        ),
        backgroundColor: const Color(0xFFF86A2E),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
               Navigator.of(context).pop();
            },
            child:Container(
              width:40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ), 
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFFF86A2E), // Orange arrow color
                size: 25, // Icon size
              ),   
            ),
          ),
        ),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _moveCameraToCurrentLocation();
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 15,
              ),
              myLocationEnabled: true, // Enable live location tracking
              polylines: _polylines, // Display the route
              markers: _markers,
            ),
    );
  }

  // Fetch live location updates
  void _getLocationUpdates() async {
    bool _serviceEnabled;
    location_package.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == location_package.PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != location_package.PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((location_package.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });

        // Update user location marker
        _addUserLocationMarker();

        // Get directions route when current location is updated
        _fetchRoute(_currentLocation!, widget.destination);
      }
    });
  }

 //add resturant marker
 void _addRestaurantMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('restaurant'),
          position: widget.destination,
          infoWindow: InfoWindow(
            title: widget.restaurantName,
            snippet: 'Your destination',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange), 
        ),
      );
    });
  }

  //add user location marker
  void _addUserLocationMarker() {
    if (_currentLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: const InfoWindow(
              title: 'Your Location',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Blue marker for current location
          ),
        );
      });
    }
  }

  // Move the camera to the current location
  void _moveCameraToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );
    }
  }

  // Fetch the route from the current location to the destination
  Future<void> _fetchRoute(LatLng origin, LatLng destination) async {
    String directionsUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_directionsApiKey";

    try {
      final response = await http.get(Uri.parse(directionsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          List<LatLng> route = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          setState(() {
            _routeCoordinates = route;
            _polylines = {
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routeCoordinates,
                color: const Color.fromARGB(255, 160, 205, 249),
                width: 5,
              ),
            };
          });
        }
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  // Decode the polyline string to LatLng coordinates
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
  }
}
