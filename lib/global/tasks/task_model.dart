import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String name;
  final String details;
  final DateTime time;
  final String userId;
  final String category;

  TaskModel({
    required this.id,
    required this.name,
    required this.details,
    required this.time,
    required this.userId,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'details': details,
      'time': time,
      'userId': userId,
      'category': category,
    };
  }

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
