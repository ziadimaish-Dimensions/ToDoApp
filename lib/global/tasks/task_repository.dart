import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/global/services/analytics_service.dart';
import 'package:to_do_app/global/tasks/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AnalyticsService _analyticsService = AnalyticsService();

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
    await _analyticsService.logTaskCreated(
      task.name,
      task.details,
      task.time.toIso8601String().split('T').first,
      task.time.toIso8601String().split('T').last,
      task.category,
    );
  }

  Future<void> updateTask(String id, TaskModel task) async {
    await _firestore.collection('tasks').doc(id).update(task.toMap());
    await _analyticsService.logTaskUpdated(
      task.name,
      task.details,
      task.time.toIso8601String().split('T').first,
      task.time.toIso8601String().split('T').last,
      task.category,
    );
  }

  Future<void> deleteTask(String id, String title) async {
    await _firestore.collection('tasks').doc(id).delete();
    await _analyticsService.logTaskDeleted(title);
  }

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromDocument(doc);
      }).toList();
    });
  }
}
