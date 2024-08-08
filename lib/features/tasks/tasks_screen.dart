import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/features/tasks/widgets/add_task_widget.dart';
import 'package:to_do_app/features/tasks/widgets/task_list_widget.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
