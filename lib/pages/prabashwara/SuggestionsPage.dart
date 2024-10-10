import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import for pie chart

class SuggestionsPage extends StatefulWidget {
  final String extractedText; // Receive extracted text from NextPage

  const SuggestionsPage({super.key, required this.extractedText});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> _userPreferences = []; // User preferences
  List<String> _matchedPreferences = []; // To store matched preferences for the pie chart
  List<Map<String, int>> _linesWithMultiplePreferences = []; // Store lines with their preference counts

  @override
  void initState() {
    super.initState();
    print("Received Extracted Text: ${widget.extractedText}"); // Debugging: print the received text
    _fetchUserPreferencesAndCompare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions Based on Preferences'),
      ),
      body: _buildSuggestionsView(),
    );
  }

  Widget _buildSuggestionsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // First Card for Pie Chart
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'User Preferences Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200, // Set the height for the pie chart
                  child: _buildPieChart(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Second Card for Matched Preferences
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Matched Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _matchedPreferences.isNotEmpty
                      ? Text(
                          _matchedPreferences.join(', '),
                          style: const TextStyle(fontSize: 16),
                        )
                      : const Text('No Preferences Matched'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // New Card for Best Suggestions
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Find our best suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _linesWithMultiplePreferences.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildHighlightedLines(),
                        )
                      : const Text('No lines found with more than two preferences.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHighlightedLines() {
    List<Widget> lineWidgets = [];
    int maxCount = _linesWithMultiplePreferences.map((e) => e.values.first).reduce((a, b) => a > b ? a : b);
    
    // Find the first line with the highest count for highlighting
    for (int i = 0; i < _linesWithMultiplePreferences.length; i++) {
      var lineData = _linesWithMultiplePreferences[i];
      String line = lineData.keys.first;
      int count = lineData.values.first;

      // Highlight the line if it has the highest count or if it is the first line
      bool isHighlighted = (count == maxCount) && (i == 0) || (i == 0 && lineWidgets.isEmpty);

      lineWidgets.add(
        Text(
          line,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Colors.red : Colors.black, // Change color for highlighted line
          ),
        ),
      );
    }

    return lineWidgets;
  }

  Widget _buildPieChart() {
    final data = _preparePieChartData();

    return PieChart(
      PieChartData(
        sections: data,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _preparePieChartData() {
    List<PieChartSectionData> sections = [];
    Map<String, int> preferencesCount = {};

    // Count the occurrences of each preference
    for (String preference in _userPreferences) {
      preferencesCount[preference] = preferencesCount.containsKey(preference) ? preferencesCount[preference]! + 1 : 1;
    }

    // Create pie chart sections
    preferencesCount.forEach((preference, count) {
      final isMatched = _matchedPreferences.contains(preference);
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: preference,
        color: isMatched ? Colors.green : Colors.blue,
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    return sections;
  }

  Future<void> _fetchUserPreferencesAndCompare() async {
    // Fetch user preferences from Firestore
    String trimmedEmail = (user?.email ?? "User email").split('@').first;
    DocumentSnapshot doc = await _firestore.collection('users').doc(trimmedEmail).get();
    _userPreferences = List<String>.from(doc['preferences'] ?? []).map((pref) => pref.toUpperCase()).toList(); // Convert preferences to upper case
    print("User Preferences: $_userPreferences"); // Debugging: print user preferences

    // Extract lines from the received text
    List<String> extractedLines = widget.extractedText.split('\n');

    // Check each line for keyword matches and collect matched preferences
    for (String line in extractedLines) {
      // Remove lines with special characters
      if (_isLineValid(line)) {
        // Check if the line matches user preferences
        if (_doesLineMatchUserPreferences(line)) {
          _matchedPreferences.add(line.toUpperCase()); // Store matched preferences
        }
        
        // Check if the line contains more than two preferences
        int matchedCount = _countMatchedPreferencesInLine(line);
        if (matchedCount >= 2) {
          _linesWithMultiplePreferences.add({line: matchedCount}); // Store lines with their preference counts
        }
      }
    }

    // Sort lines with multiple preferences based on the count
    _linesWithMultiplePreferences.sort((a, b) => b.values.first.compareTo(a.values.first));

    // Update the UI if there are matched preferences
    setState(() {});
  }

  bool _isLineValid(String line) {
    // Check for special characters using a regex
    final RegExp specialCharacters = RegExp(r'[^a-zA-Z0-9\s]');
    return !specialCharacters.hasMatch(line); // Return true if line has no special characters
  }

  bool _doesLineMatchUserPreferences(String line) {
    String upperCaseLine = line.toUpperCase(); // Convert line to upper case
    // Check if any preference matches the line
    for (String preference in _userPreferences) {
      if (upperCaseLine.contains(preference)) {
        return true; // Return true if a match is found
      }
    }
    return false; // No matches found
  }

  int _countMatchedPreferencesInLine(String line) {
    int count = 0;
    String upperCaseLine = line.toUpperCase(); // Convert line to upper case
    // Count how many preferences are in the line
    for (String preference in _userPreferences) {
      if (upperCaseLine.contains(preference)) {
        count++;
      }
    }
    return count; // Return the count of matched preferences
  }
}
