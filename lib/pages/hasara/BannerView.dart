import 'package:flutter/material.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the height as 25% of the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.25; // 25% of the screen height

    return Container(
      height: containerHeight, // Set the height of the container
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
    );
  }
}
