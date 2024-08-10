import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/features/tasks/widgets/add_task_widget.dart';
import 'package:to_do_app/features/tasks/widgets/task_list_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

/// The `HomeScreen` displays the list of tasks for the currently signed-in user.
/// It includes an option to add new tasks and handles keyboard dismissal when the user taps outside of an input field.

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Tasks',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
          body: TaskList(userId: _currentUser!.uid),
          floatingActionButton: AddTaskWidget(userId: _currentUser!.uid),
        ),
      ),
    );
  }
}
