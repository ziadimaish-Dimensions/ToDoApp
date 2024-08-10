import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/global/services/analytics_service.dart';
import 'package:to_do_app/global/tasks/task_model.dart';

/// The `TaskRepository` handles all operations related to tasks in Firestore,
/// including adding, updating, deleting, and retrieving tasks. It also logs
/// relevant events to Firebase Analytics.

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AnalyticsService _analyticsService = AnalyticsService();

  /// Adds a new task to the Firestore database and logs the task creation event to Firebase Analytics.
  ///
  /// Parameters:
  /// - `task`: The `TaskModel` instance representing the task to be added.
  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
    await _analyticsService.logTaskCreated(
      task.name,
      task.details,
      task.time
          .toIso8601String()
          .split('T')
          .first, //extract the date portion from the datetime object
      task.time.toIso8601String().split('T').last,
      task.category,
    );
  }

  /// Updates an existing task in the Firestore database and logs the task update event to Firebase Analytics.
  ///
  /// Parameters:
  /// - `id`: The unique identifier of the task to be updated.
  /// - `task`: The updated `TaskModel` instance.
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

  /// Deletes a task from the Firestore database and logs the task deletion event to Firebase Analytics.
  ///
  /// Parameters:
  /// - `id`: The unique identifier of the task to be deleted.
  /// - `title`: The title of the task to be deleted, used for logging purposes.
  Future<void> deleteTask(String id, String title) async {
    await _firestore.collection('tasks').doc(id).delete();
    await _analyticsService.logTaskDeleted(title);
  }

  /// Retrieves a stream of tasks for a specific user from the Firestore database.
  ///
  /// Parameters:
  /// - `userId`: The unique identifier of the user whose tasks are to be retrieved.
  ///
  /// Returns:
  /// A `Stream` of a list of `TaskModel` objects representing the tasks of the user.
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
