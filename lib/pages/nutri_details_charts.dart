import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/pages/nutriProgressCardWidget.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NutriDetailsCharts extends StatefulWidget {
  final String name;
  final int id;
  final Map<String, dynamic> response;

  const NutriDetailsCharts({
    super.key,
    required this.name,
    required this.id,
    required this.response,
  });

  @override
  State<NutriDetailsCharts> createState() => _NutriDetailsChartsState();
}

class _NutriDetailsChartsState extends State<NutriDetailsCharts> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate data fetching delay (you can replace this with actual API call or data processing)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Data is ready, stop loading
      });
    });

    print('jsonNutri: ${widget.response['nutrients']}'); // Print the data
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.name} Analysis',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Custom Card widget above the GridView
              NutriProgressCard(
                height: h,
                width: w,
                data: widget.response,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 10), // Space between progress bars
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250, // Max width of a card
                    crossAxisSpacing: 10.0, // Space between columns
                    mainAxisSpacing: 10.0, // Space between rows
                  ),
                  itemCount: widget.response['nutrients'].length,
                  itemBuilder: (context, index) {
                    final nutri = widget.response['nutrients'][index];
                    return _isLoading
                        ? const Center(
                            child: SpinKitFadingCircle(
                              color: Color.fromARGB(192, 187, 5, 5),
                              size: 50.0,
                            ),
                          )
                        : IndividualNutrientCard(
                            nutrients: nutri['name'],
                            amount: nutri['amount'].toDouble().toString(),
                            unit: nutri['unit'],
                            progress:
                                nutri['percentOfDailyNeeds'].toDouble() / 100.0,
                            progressColor:
                                getRandomColor(), // Generate a random color
                            dailyPercent:
                                nutri['percentOfDailyNeeds'].toDouble(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IndividualNutrientCard extends StatelessWidget {
  final String nutrients;
  final String amount;
  final String unit;
  final double progress;
  final Color progressColor;
  final double dailyPercent;

  // Constructor to accept a fixed color
  const IndividualNutrientCard(
      {super.key,
      required this.nutrients,
      required this.amount,
      required this.unit,
      required this.progress,
      required this.progressColor,
      required this.dailyPercent});

  // Function to get the nutrient-specific icon
  IconData getNutrientIcon(String nutrientName) {
    switch (nutrientName.toLowerCase()) {
      case 'protein':
        return Icons.fitness_center;
      case 'carbohydrates':
        return Icons.bakery_dining;
      case 'net carbohydrates':
        return Icons.bakery_dining;
      case 'fat':
        return Icons.fastfood;
      case 'saturated fat':
        return Icons.fastfood;
      case 'fiber':
        return Icons.grass;
      case 'vitamins':
        return Icons.local_florist;
      case 'calcium':
        return Icons.local_drink;
      case 'iron':
        return Icons.whatshot;
      case 'sodium':
        return Icons.spa;
      case 'sugar':
        return Icons.cake;
      default:
        return Icons.auto_fix_normal_outlined; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Card shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(10), // Padding inside the card
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: <Widget>[
            // Row with nutrient name and icon
            Row(
              children: <Widget>[
                Text(
                  // Check if there are exactly two words and join with a newline
                  nutrients.split(' ').length == 2
                      ? nutrients
                          .split(' ')
                          .join('\n') // If exactly two words, add newline
                      : nutrients, // Otherwise, display the nutrient normally
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 3, // Allow up to 3 lines for wrapping
                  overflow:
                      TextOverflow.visible, // Make sure text wraps to next line
                ),
                Spacer(), // Align icon to the right
                Icon(
                  getNutrientIcon(nutrients), // Generate icon
                  color:
                      progressColor, // Match icon color with the progress color
                  size: 35, // Set icon size
                ),
              ],
            ),
            const SizedBox(
                height: 10), // Space between nutrient name and progress bar

            // Row with progress bar and amount
            Row(
              children: <Widget>[
                const SizedBox(
                    width: 15), // Space between progress bar and amount
                // Progress bar
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 90, // Height of the progress bar
                  width: 25, // Width of the progress bar
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: progressColor
                        .withOpacity(0.3), // Background of progress bar
                    border: Border.all(
                      // Add a border with a specific color
                      color: progressColor, // Use the passed border color
                      width: 1, // Border width
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter, // Align the progress bar
                    children: <Widget>[
                      Container(
                        height: 90 * progress, // Scale height based on progress
                        width: 25, // Match the background width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: progressColor, // Use the passed fixed color
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 5), // Space between progress bar and amount

                // Expanded widget to avoid overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to the start
                    children: <Widget>[
                      // Display the amount (e.g., 150g)
                      FittedBox(
                        fit: BoxFit
                            .scaleDown, // Ensure text fits within available space
                        child: Text(
                          '$amount$unit',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black, // Black text color
                          ),
                          maxLines: 2, // Ensure single line
                          overflow: TextOverflow.visible, // Handle overflow
                        ),
                      ),
                      //display bottom text at the end of the card
                      const SizedBox(height: 10),
                      Text(
                        'Daily Needs: ${dailyPercent.toDouble()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(
                              255, 100, 100, 100), // Black text color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Function to generate a random color
Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255, // Alpha value (opacity)
    random.nextInt(256), // Red value
    random.nextInt(125), // Green value
    random.nextInt(256), // Blue value
  );
}
