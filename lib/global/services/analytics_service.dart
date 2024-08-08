import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

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

  Future<void> logTaskDeleted(String title) async {
    await _analytics.logEvent(
      name: 'task_deleted',
      parameters: {
        'title': title,
      },
    );
  }
}
