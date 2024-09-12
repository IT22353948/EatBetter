import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  final String extractedText;

  const NextPage({Key? key, required this.extractedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Text'),
        backgroundColor: const Color(0xFFF86A2E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                extractedText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
