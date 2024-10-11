import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomeAnalysis extends StatelessWidget {
  final Map<String, dynamic> nutritionData;
  final bool isLoading; // Add isLoading parameter

  const CustomeAnalysis({
    super.key,
    required this.nutritionData,
    this.isLoading = false, // Default to false if not provided
  });

  @override
  Widget build(BuildContext context) {
    // Check if the nutritionData contains an 'error' key
    final bool hasError = nutritionData.containsKey('error');

    // Transform the nutrition data into a list of items if no error
    final nutrientsList = hasError ? [] : nutritionData.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Custome Nutrition Analysis')),
        backgroundColor: const Color.fromARGB(126, 248, 100, 37),
        leading: IconButton(
          iconSize: 30,
          icon: Image.asset('assets/icons/BackButton.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255), // White
              Colors.white, // White
            ],
          ),
        ),
        child: isLoading // Check if loading
            ? const Center(
                child: SpinKitFadingCircle(
                  color: Color.fromARGB(192, 187, 5, 5),
                  size: 50.0,
                ),
              )
            : hasError // Check if there is an error
                ? Center(
                    child: Text(
                      nutritionData['error'], // Display the error message
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                      textAlign:
                          TextAlign.center, // Center-align the error message
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two items per row
                      childAspectRatio: 1, // Aspect ratio for cards
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                    ),
                    itemCount:
                        nutrientsList.length, // Total number of nutrients
                    itemBuilder: (context, index) {
                      final nutrient = nutrientsList[index].value;
                      return NutrientCard(
                        label: nutrient['label'],
                        quantity: nutrient['quantity'],
                        unit: nutrient['unit'],
                      );
                    },
                  ),
      ),
    );
  }
}

class NutrientCard extends StatelessWidget {
  final String label;
  final double quantity;
  final String unit;

  const NutrientCard({
    super.key,
    required this.label,
    required this.quantity,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Card(
      elevation: 8, // Increased elevation for a stronger shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // More rounded corners
      ),
      child: Container(
        padding: const EdgeInsets.all(10), // Increased padding
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Light yellow
              Color.fromARGB(255, 255, 255, 255), // White
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Make the column take only the minimum space required
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: w * 0.055, // Adjust font size based on screen width
                fontWeight: FontWeight.bold,
                color:
                    const Color.fromARGB(255, 150, 22, 0), // Darker text color
              ),
            ),
            const SizedBox(height: 10), // Space between label and quantity
            Text(
              '${quantity.ceilToDouble()} $unit',
              style: TextStyle(
                fontSize: w * 0.045, // Adjust font size based on screen width
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
