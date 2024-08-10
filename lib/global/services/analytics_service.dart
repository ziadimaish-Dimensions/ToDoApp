import 'package:firebase_analytics/firebase_analytics.dart';

/// The `AnalyticsService` handles logging custom events related to tasks in Firebase Analytics.
/// It provides methods to log task creation, updates, and deletions.

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Logs an event when a task is created.
  ///
  /// Parameters:
  /// - `title`: The title of the created task.
  /// - `description`: A brief description of the task.
  /// - `date`: The date when the task is scheduled.
  /// - `time`: The time when the task is scheduled.
  /// - `category`: The category under which the task falls.
  Future<void> logTaskCreated(String title, String description, String date,
      String time, String category) async {
    await _analytics.logEvent(
      name: 'task_created',
      parameters: {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'category': category,
      },
    );
  }

  /// Logs an event when a task is updated.
  ///
  /// Parameters:
  /// - `title`: The title of the updated task.
  /// - `description`: A brief description of the updated task.
  /// - `date`: The updated date of the task.
  /// - `time`: The updated time of the task.
  /// - `category`: The updated category of the task.
  Future<void> logTaskUpdated(String title, String description, String date,
      String time, String category) async {
    await _analytics.logEvent(
      name: 'task_updated',
      parameters: {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'category': category,
      },
    );
  }

  /// Logs an event when a task is deleted.
  ///
  /// Parameters:
  /// - `title`: The title of the deleted task.
  Future<void> logTaskDeleted(String title) async {
    await _analytics.logEvent(
      name: 'task_deleted',
      parameters: {
        'title': title,
      },
    );
  }
}
