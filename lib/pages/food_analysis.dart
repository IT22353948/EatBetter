import 'package:flutter/material.dart';

class FoodAnalysis extends StatefulWidget {
  const FoodAnalysis({super.key});

  @override
  State<FoodAnalysis> createState() => _FoodAnalysisState();
}

class _FoodAnalysisState extends State<FoodAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Food Analysis'),
      //   backgroundColor: const Color.fromARGB(255, 150, 22, 0),
      // ),
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
            children: const <Widget>[
              Text(
                'Food Analysis',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//to add the gradient
//wrap below code in container. see food_analysis.dart for more details
// decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(126, 248, 100, 37), // Orange
//               Colors.white, // White
//             ],
//           ),
//         ),