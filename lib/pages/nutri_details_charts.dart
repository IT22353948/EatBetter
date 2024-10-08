import 'package:flutter/material.dart';

class NutriDetailsCharts extends StatefulWidget {
  final String name;
  final int id;
  final Map<String, dynamic> nutri1;
  final Map<String, dynamic> nutri2;
  final Map<String, dynamic> nutri3;
  final Map<String, dynamic> nutri4;
  final Map<String, dynamic> nutri5;
  final Map<String, dynamic> nutri6;

  const NutriDetailsCharts({
    super.key,
    required this.name,
    required this.id,
    required this.nutri1,
    required this.nutri2,
    required this.nutri3,
    required this.nutri4,
    required this.nutri5,
    required this.nutri6,
  });

  @override
  State<NutriDetailsCharts> createState() => _NutriDetailsChartsState();
}

class _NutriDetailsChartsState extends State<NutriDetailsCharts> {
  @override
  void initState() {
    super.initState();
    print('data: ${widget.nutri1}'); // Print the data
    print('data: ${widget.nutri2}'); // Print the data
    print('data: ${widget.nutri3}'); // Print the data
    print('data: ${widget.nutri4}'); // Print the data
    print('data: ${widget.nutri5}'); // Print the data
    print('data: ${widget.nutri6}'); // Print the data
  }

  @override
  Widget build(BuildContext context) {
    // Store the nutrient data in a list for easy access in the grid
    final List<Map<String, dynamic>> nutrients = [
      widget.nutri1,
      widget.nutri2,
      widget.nutri3,
      widget.nutri4,
      widget.nutri5,
      widget.nutri6,
    ];

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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250, // Max width of a card
              crossAxisSpacing: 10.0, // Space between columns
              mainAxisSpacing: 10.0, // Space between rows
            ),
            itemCount: nutrients.length,
            itemBuilder: (context, index) {
              final nutri = nutrients[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${nutri['name']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            'amount: ${nutri['amount'].toString()}\n\ndetails: ${nutri.toString()}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
