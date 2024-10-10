import 'package:eat_better/authFile/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesView extends StatefulWidget {
  @override
  State<PreferencesView> createState() => _PointsPageState();
}

class _PointsPageState extends State<PreferencesView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = Auth().CurrentUser; // Current logged-in user

  Set<String> _userPreferences = {}; // Stores the user preferences
  bool _preferencesLoaded = false; // Tracks loading state

  @override
  void initState() {
    super.initState();
    _fetchUserPreferences(); // Fetch the preferences once the widget is initialized
  }

  Future<void> _fetchUserPreferences() async {
    String trimmedEmail = (user?.email ?? "User email").split('@').first;

    // Fetch user preferences from Firestore
    DocumentSnapshot doc = await _firestore.collection('users').doc(trimmedEmail).get();

    if (doc.exists) {
      setState(() {
        _userPreferences = Set<String>.from(doc['preferences'] ?? []); // Retrieve preferences
        _preferencesLoaded = true; // Indicate preferences are loaded
      });
    } else {
      setState(() {
        _preferencesLoaded = true; // No preferences found, but still mark as loaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String trimmedEmail = (user?.email ?? "User email").split('@').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Preferences'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                trimmedEmail,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _preferencesLoaded
              ? _userPreferences.isNotEmpty
                  ? Column(
                      children: [
                        const Text('Your Preferences:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _userPreferences.length,
                            itemBuilder: (context, index) {
                              String preference = _userPreferences.elementAt(index);
                              return ListTile(
                                title: Text(preference, style: const TextStyle(fontSize: 18)),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Text('No preferences found.') // Message if no preferences
              : const CircularProgressIndicator(), // Show loading indicator while fetching preferences
        ),
      ),
    );
  }
}
