import 'package:flutter/material.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the height as 65% of the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.70; // 65% of the screen height

    return Container(
      height: screenHeight, // Full height for the gradient background
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
      child: Column(
        children: [
          Container(
            height: containerHeight, // Set the height of the inner white container
            margin: const EdgeInsets.all(16.0), // Add margin around the container
            padding: const EdgeInsets.all(16.0), // Add padding inside the container
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(16), // Optional: Add some border radius
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12, // Increased blur radius for a softer shadow
                  offset: Offset(0, 4), // Shadow offset
                  spreadRadius: 2, // Add spread radius for larger shadow effect
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to Restaurant Finder!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/location_view'); // Navigate to MapView
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF86A2E),
                    ),
                    child: const Text("Show Map"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
