import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/features/tasks/views/task_details_screen.dart';
import 'package:to_do_app/global/tasks/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  TaskTile({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          title: Text(task.name, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(task.details, style: const TextStyle(color: Colors.white70)),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          ),
        ),
      ),
    );
  }
}
