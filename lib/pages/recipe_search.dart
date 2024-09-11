import 'package:flutter/material.dart';

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({super.key});

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
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
                'Recipe Search',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
