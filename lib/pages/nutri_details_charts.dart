import 'package:flutter/material.dart';
import 'package:eat_better/pages/nutriProgressCardWidget.dart';
import 'dart:math';

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
                    return IndividualNutrientCard(
                      nutrients: nutri['name'],
                      amount: nutri['amount'],
                      unit: nutri['unit'],
                      progress: nutri['percentOfDailyNeeds'] / 100,
                      progressColor:
                          getRandomColor(), // Generate a random color
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
  final double amount;
  final String unit;
  final double progress;
  final Color progressColor;

  // Constructor to accept a fixed color
  const IndividualNutrientCard(
      {super.key,
      required this.nutrients,
      required this.amount,
      required this.unit,
      required this.progress,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Card shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(20), // Padding inside the card
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: <Widget>[
            // Nutrient name
            Text(
              nutrients,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: progressColor),
              overflow:
                  TextOverflow.ellipsis, // Avoid overflow in nutrient name
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
                      width: 2, // Border width
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
                  child: FittedBox(
                    fit: BoxFit
                        .scaleDown, // Ensure text fits within available space
                    child: Text(
                      '${amount.toString()}$unit',
                      style: TextStyle(
                        fontSize: 18,
                        color: progressColor,
                      ),
                      maxLines: 2, // Ensure single line
                      overflow: TextOverflow.visible, // Handle overflow
                    ),
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
