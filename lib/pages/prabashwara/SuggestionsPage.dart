import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart'; // For displaying suggestions as chat messages

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
  List<ChatMessage> messages = []; // Suggestions as chat messages

  final ChatUser geminiUser = ChatUser(id: "1", firstName: "Gemini");

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
      child: messages.isNotEmpty
          ? DashChat(
              currentUser: ChatUser(id: "0", firstName: "User"),
              messages: messages,
              onSend: (ChatMessage message) {}, // User cannot send, only view suggestions
            )
          : const Center(child: CircularProgressIndicator()), // Show loading while fetching suggestions
    );
  }

  Future<void> _fetchUserPreferencesAndCompare() async {
    // Fetch user preferences from Firestore
    String trimmedEmail = (user?.email ?? "User email").split('@').first;
    DocumentSnapshot doc = await _firestore.collection('users').doc(trimmedEmail).get();
    _userPreferences = List<String>.from(doc['preferences'] ?? []).map((pref) => pref.toUpperCase()).toList(); // Convert preferences to upper case
    print("User Preferences: $_userPreferences"); // Debugging: print user preferences

    // Extract lines from the received text
    List<String> extractedLines = widget.extractedText.split('\n');

    // Check each line for keyword matches and collect suggestions
    for (String line in extractedLines) {
      // Remove lines with special characters
      if (_isLineValid(line)) {
        // Check if the line matches user preferences
        if (_doesLineMatchUserPreferences(line)) {
          print("Line: '$line' matches user preferences."); // Debugging: print matched lines
          messages.add(ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: line, // Add matched line as a suggestion
          ));
        }
      }
    }

    // Update the UI if there are suggestions
    if (messages.isNotEmpty) {
      setState(() {
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // Sort messages by time
      });
    } else {
      print("No valid lines found."); // Indicate no lines found
    }
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
}
