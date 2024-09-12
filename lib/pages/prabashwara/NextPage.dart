import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  final String extractedText;

  const NextPage({Key? key, required this.extractedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Process the extracted text to filter out menu items
    final List<String> menuItems = _processExtractedText(extractedText);

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
              if (menuItems.isEmpty)
                const Center(child: Text('No menu items found')),
              ...menuItems.map((item) => _buildMenuCard(item)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to process the extracted text and return a list of menu items
  List<String> _processExtractedText(String text) {
    // Split the text into lines
    final lines = text.split('\n');

    // Filter out headings and extract menu items
    // For simplicity, let's assume headings are lines with all uppercase letters
    return lines
        .where((line) => line.isNotEmpty && !RegExp(r'^[A-Z\s]+$').hasMatch(line))
        .toList();
  }

  // Function to build a card widget for each menu item
  Widget _buildMenuCard(String item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
