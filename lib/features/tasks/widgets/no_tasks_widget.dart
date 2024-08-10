import 'package:flutter/material.dart';

/// The `NoTasksWidget` displays a message and an image when there are no tasks to show.
/// It encourages the user to add new tasks.

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/tasks_image.png'),
          const SizedBox(height: 10),
          const Text(
            'What do you want to do today?',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tap + to add your tasks',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
