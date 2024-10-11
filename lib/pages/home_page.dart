import 'package:eat_better/authFile/auth.dart';
import 'package:eat_better/authFile/login_register.dart';
import 'package:eat_better/authFile/widget_tree.dart';
import 'package:eat_better/pages/prabashwara/SuggestionsPage.dart';
import 'package:eat_better/pages/prabashwara/Preferences/preference_page.dart';
import 'package:flutter/material.dart';
import 'prabashwara/Image_To_Text.dart';
import 'food_analysis.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Sign out method
  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Auth().CurrentUser;
    String trimmedEmail = (user?.email ?? "User").split('@').first; // Trimmed email

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EatBetter'),
        backgroundColor: const Color(0xFFF86A2E), // AppBar color
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  trimmedEmail,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    signOut(context); // Sign out and navigate to login
                  },
                ),
              ],
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Adjust aspect ratio for card size
          children: [
            _buildNavigationCard(
              context,
              'Text Scanner',
              'Scan and extract text from images',
              Icons.camera_alt,
              ImageToText(),
              Colors.teal, // Icon color
              Color(0xFFF86A2E), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Preferences',
              'Explore and discover new recipes',
              Icons.abc_sharp,
              UserPreferencePage(), // Replace with the actual Preferences screen
              Colors.deepOrange, // Icon color
              Color(0xFF3498db), // Card border color
            ),
            _buildNavigationCard(
              context,
              'Show Preferences',
              'View your favorite dishes',
              Icons.favorite,
              const SuggestionsPage(extractedText: ''), // Replace with the actual Favorites screen
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
              'Sample Card',
              'Lorem ipsum',
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
        borderRadius: BorderRadius.circular(12.0), // Slightly rounded corners
      ),
      elevation: 8, // Increased elevation for better shadow
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0), // Matching border radius
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Added padding inside card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60, // Slightly larger icon
                color: iconColor, // Custom icon color
              ),
              const SizedBox(height: 12), // Increased spacing
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20, // Larger title text
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16, // Larger subtitle text
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
