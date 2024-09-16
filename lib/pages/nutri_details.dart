import 'package:flutter/material.dart';

class NutriDetails extends StatelessWidget {
  final int id;
  final String imageUrl;

  const NutriDetails({super.key, required this.id, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritional Details'),
        backgroundColor: Color.fromARGB(126, 248, 100, 37),
        leading: IconButton(
          iconSize: 30,
          icon: Image.asset('assets/icons/BackButton.png'),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        // Apply gradient background
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
              // Display image in a centered circle
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                'Nutritional Details for ID: $id',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
