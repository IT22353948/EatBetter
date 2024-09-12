import 'dart:ffi';
import 'package:flutter/material.dart';
import 'Image_To_Text.dart';
import 'food_analysis.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EatBetter'),
        backgroundColor: const Color(0xFFF86A2E), // AppBar color
      ),
      body: Container(
        
        color: const Color(0xFFF5F5F5), // Background color for the body
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildNavigationCard(
              context,
              'Text Scanner',
              'Scan and extract text from images',
              Icons.camera_alt,
              HomePageImageToText(),
              Colors.teal, // Icon color
              Color(0xFFF86A2E), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Recipes',
              'Explore and discover new recipes',
              Icons.restaurant_menu,
              Container(), // Replace with the actual Recipes screen
              Colors.deepOrange, // Icon color
              Color(0xFF3498db), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Favorites',
              'View your favorite dishes',
              Icons.favorite,
              Container(), // Replace with the actual Favorites screen
              Colors.pinkAccent, // Icon color
              Color(0xFF27AE60), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Settings',
              'Adjust your app settings',
              Icons.settings,
              Container(), // Replace with the actual Settings screen
              Colors.grey, // Icon color
              Color(0xFF8E44AD), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Food Analysis',
              'Analyze the nutritional value of food',
              Icons.analytics_sharp,
              FoodAnalysis(), // Replace with the actual Food Analysis screen
              Colors.blue, // Icon color
              Color(0xFFE67E22), // Card border color
            ),
            _buildNavigationCard(
              context,
              'sample card',
              'lorem ipsam',
              Icons.access_time_sharp,
              FoodAnalysis(), // Replace with the actual Food Analysis screen
              Colors.blue, // Icon color
              Color(0xFFE67E22), // Card border color
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget destination,
    Color iconColor,
    Color borderColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2), // Custom card border color
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: iconColor, // Custom icon color
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
