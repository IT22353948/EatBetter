import 'package:flutter/material.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to Restaurant Finder!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/location_view'); // Navigate to MapView
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF86A2E),
            ),
            child: const Text("Show Map"),
          ),
        ],
      ),
    );
  }
}
