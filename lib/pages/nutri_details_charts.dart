import 'package:flutter/material.dart';

class NutriDetailsCharts extends StatefulWidget {
  final String name;
  final Map<String, dynamic> nutriData; // Accept the data through constructor

  const NutriDetailsCharts(
      {super.key, required this.nutriData, required this.name});

  @override
  State<NutriDetailsCharts> createState() => _NutriDetailsChartsState();
}

class _NutriDetailsChartsState extends State<NutriDetailsCharts> {
  initState() {
    super.initState();
    print('data: ${widget.nutriData['nutrients'][5]}'); // Print the data
    print('data: ${widget.nutriData['nutrients'][7]}'); // Print the data
    print('data: ${widget.nutriData['nutrients'][10]}'); // Print the data
    print('data: ${widget.nutriData['nutrients'][12]}'); // Print the data
    print('data: ${widget.nutriData['nutrients'][17]}'); // Print the data
    print('data: ${widget.nutriData['nutrients'][22]}'); // Print the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Flexible(
          child: Center(
            child: Text(
              '${widget.name} Analysis',
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(fontSize: 20),
              overflow:
                  TextOverflow.visible, // Adds "..." if the text is too long
            ),
          ),
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nutri details charts',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
