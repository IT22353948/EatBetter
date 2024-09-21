import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  late String userId;
  late List<String> preferences;

  Todo({
    required this.userId,
    required this.preferences,
  });

  // From JSON to Todo object
  Todo.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId']! as String,
          preferences: List<String>.from(json['preferences'] as List),
        );

  // For updating specific fields of the Todo object
  Todo copyWith({
    String? userId,
    List<String>? preferences,
  }) {
    return Todo(
      userId: userId ?? this.userId,
      preferences: preferences ?? this.preferences,
    );
  }

  // To convert the Todo object to JSON
  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'preferences': preferences,
    };
  }
}
