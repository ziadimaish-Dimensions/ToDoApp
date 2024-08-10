import 'package:flutter/material.dart';
import 'package:to_do_app/features/tasks/widgets/no_tasks_widget.dart';
import 'package:to_do_app/features/tasks/widgets/task_tile_widget.dart';
import 'package:to_do_app/global/tasks/task_model.dart';
import 'package:to_do_app/global/tasks/task_repository.dart';

/// The `TaskList` widget displays a list of tasks for a specific user.
/// It shows a loading indicator while tasks are being fetched and displays a message if no tasks are found.

class TaskList extends StatelessWidget {
  final String userId;
  final TaskRepository _taskRepository = TaskRepository();

  TaskList({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: _taskRepository.getTasks(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const NoTasksWidget();
        }
        final tasks = snapshot.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskTile(task: task);
          },
        );
      },
    );
  }
}
