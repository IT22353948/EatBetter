import 'package:flutter/material.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the height as 70% of the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.70; // 70% of the screen height

    return Container(
      height: screenHeight, // Full height for the gradient background
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(126, 248, 100, 37),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            height: containerHeight,
            margin: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
            padding: const EdgeInsets.all(16.0),
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
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to Restaurant Finder!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/location_view'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 249, 93, 26),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ), 
              ),
              child: const Text(
                "View Map",
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 18, // Optional: Adjust font size if needed
                  fontWeight: FontWeight.bold, // Optional: Make the text bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
