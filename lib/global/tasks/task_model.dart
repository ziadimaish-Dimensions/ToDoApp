import 'package:cloud_firestore/cloud_firestore.dart';

/// The `TaskModel` class represents a task in the application.
/// It includes properties such as `id`, `name`, `details`, `time`, `userId`, and `category`.

class TaskModel {
  final String id;
  final String name;
  final String details;
  final DateTime time;
  final String userId;
  final String category;

  /// Constructs a `TaskModel` object with the required parameters.
  ///
  /// Parameters:
  /// - `id`: The unique identifier for the task.
  /// - `name`: The name or title of the task.
  /// - `details`: A description or details of the task.
  /// - `time`: The scheduled date and time for the task.
  /// - `userId`: The ID of the user who created the task.
  /// - `category`: The category under which the task is classified.
  TaskModel({
    required this.id,
    required this.name,
    required this.details,
    required this.time,
    required this.userId,
    required this.category,
  });

  /// Converts the `TaskModel` instance to a `Map` object, which is useful for
  /// storing the task data in Firestore or other databases.
  ///
  /// Returns:
  /// A map representation of the `TaskModel` object.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'details': details,
      'time': time,
      'userId': userId,
      'category': category,
    };
  }

  /// Creates a `TaskModel` instance from a Firestore `DocumentSnapshot`.
  ///
  /// Parameters:
  /// - `doc`: A `DocumentSnapshot` from Firestore that contains task data.
  ///
  /// Returns:
  /// A `TaskModel` object populated with data from the Firestore document.
  static TaskModel fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      name: data['name'] ?? '',
      details: data['details'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
