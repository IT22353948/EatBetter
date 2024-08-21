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
      appBar: AppBar(
        title: const Text('Food Analysis'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
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
    );
  }
}
