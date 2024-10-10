import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // For Gemini AI
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
  List<ChatMessage> messages = []; // Gemini suggestions as chat messages

  final ChatUser geminiUser = ChatUser(id: "1", firstName: "Gemini");
  Gemini gemini = Gemini.instance;

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
    List<String> linesToSendToGemini = []; // Store lines to send to Gemini

    for (String line in extractedLines) {
      // Remove lines with special characters
      if (_isLineValid(line)) {
        List<String> matchedKeywords = _getMatchedKeywords(line);
        print("Line: '$line' - Matched Keywords: $matchedKeywords"); // Debugging: print matched keywords

        if (matchedKeywords.isNotEmpty) {
          // If line has matched preferences, add it to the lines to send to Gemini
          linesToSendToGemini.add(line);
        }
      }
    }

    // If there are valid lines to send to Gemini, request suggestions
    if (linesToSendToGemini.isNotEmpty) {
      await _getGeminiSuggestions(linesToSendToGemini);
    } else {
      print("No valid lines found for Gemini. No requests sent."); // Indicate no lines for Gemini
    }
  }

  bool _isLineValid(String line) {
    // Check for special characters using a regex
    final RegExp specialCharacters = RegExp(r'[^a-zA-Z0-9\s]');
    return !specialCharacters.hasMatch(line); // Return true if line has no special characters
  }

  List<String> _getMatchedKeywords(String line) {
    List<String> matchedKeywords = [];
    String upperCaseLine = line.toUpperCase(); // Convert line to upper case
    for (String preference in _userPreferences) {
      if (upperCaseLine.contains(preference)) {
        matchedKeywords.add(preference);
      }
    }
    return matchedKeywords; // Return all matched keywords in the line
  }

  Future<void> _getGeminiSuggestions(List<String> linesToSend) async {
    for (String line in linesToSend) {
      print("Requesting suggestion for line: $line"); // Debugging: print the line

      gemini.streamGenerateContent(line).listen((event) {
        String? suggestion = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
        
        print("Gemini Suggestion: $suggestion"); // Debugging: print the suggestion

        ChatMessage newMessage = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: suggestion);
        setState(() {
          messages.add(newMessage); // Add Gemini's suggestion to the chat
        });
      });
    }
  }
}
