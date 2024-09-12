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
              // Container with custom width and height
              Container(
                width: double.infinity, // Set to take the full width of the screen
                height: 600, // Set height to 600 pixels
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView( // In case text overflows
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
              // Buttons below the container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First button with custom size and color
                  ElevatedButton(
                    onPressed: () {
                      // First button action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0), // Custom button size
                      backgroundColor: Colors.teal, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      'Give Suggest',
                      style: TextStyle(
                        fontSize: 18, 
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                  // Second button with custom size and color
                  ElevatedButton(
                    onPressed: () {
                      // Second button action
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0), // Adjusted button size
                      backgroundColor: Colors.orange, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
                      ),
                    ),
                    child: const Text(
                      ' Mark ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to process the extracted text and return a list of menu items, ignoring numbers, special characters, and single characters
  List<String> _processExtractedText(String text) {
    // Split the text into lines
    final lines = text.split('\n');

    // Filter out lines that contain only numbers, special characters, or single characters
    return lines
        .where((line) => line.isNotEmpty && RegExp(r'[a-zA-Z]').hasMatch(line)) // Check if the line contains any alphabetic characters
        .map((line) => line.replaceAll(RegExp(r'[^a-zA-Z\s]'), '')) // Remove special characters and numbers
        .where((line) => line.split(' ').any((word) => word.length > 1)) // Remove lines with single characters
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
