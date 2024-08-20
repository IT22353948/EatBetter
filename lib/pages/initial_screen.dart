
import 'package:flutter/material.dart';
import 'Image_To_Text.dart'; 

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Foodie App'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
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
              HomePage(),
            ),
            _buildNavigationCard(
              context,
              'Recipes',
              'Explore and discover new recipes',
              Icons.restaurant_menu,
              Container(), // Replace with the actual Recipes screen
            ),
            _buildNavigationCard(
              context,
              'Favorites',
              'View your favorite dishes',
              Icons.favorite,
              Container(), // Replace with the actual Favorites screen
            ),
            _buildNavigationCard(
              context,
              'Settings',
              'Adjust your app settings',
              Icons.settings,
              Container(), // Replace with the actual Settings screen
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
  ) {
    return Card(
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
              color: Colors.teal,
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
