import 'package:flutter/material.dart';
import 'package:to_do_app/global/task_model.dart';
import 'package:to_do_app/global/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/global/widgets/dismiss_keyboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  void _addTask() {
    if (_nameController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _currentUser == null) {
      return;
    }
    final dateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
    final task = TaskModel(
      id: '',
      name: _nameController.text,
      details: _detailsController.text,
      time: dateTime,
      userId: _currentUser!.uid,
    );
    _taskRepository.addTask(task);
    _nameController.clear();
    _detailsController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  void _updateTask(String id) {
    if (_nameController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _currentUser == null) {
      return;
    }
    final dateTime = DateTime(_selectedDate!.year, _selectedDate!.month,
        _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
    final task = TaskModel(
      id: id,
      name: _nameController.text,
      details: _detailsController.text,
      time: dateTime,
      userId: _currentUser!.uid,
    );
    _taskRepository.updateTask(id, task);
    _nameController.clear();
    _detailsController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  void _deleteTask(String id) {
    _taskRepository.deleteTask(id);
  }

  void _viewTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task.name),
          content: Text(task.details),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('To-Do List'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _detailsController,
                      decoration: InputDecoration(
                        labelText: 'Task Details',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No date chosen!'
                                : 'Picked Date: ${_selectedDate!.toLocal()}'
                                    .split(' ')[0],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Choose Date'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedTime == null
                                ? 'No time chosen!'
                                : 'Picked Time: ${_selectedTime!.format(context)}',
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTime(context),
                          child: Text('Choose Time'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addTask,
                      child: Text('Add Task'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<TaskModel>>(
                  stream: _taskRepository.getTasks(_currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No tasks yet'));
                    }
                    final tasks = snapshot.data!;
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Dismissible(
                          key: Key(task.id),
                          background: Container(color: Colors.red),
                          secondaryBackground: Container(color: Colors.blue),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              _deleteTask(task.id);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              // Open update dialog
                              _nameController.text = task.name;
                              _detailsController.text = task.details;
                              _selectedDate = task.time;
                              _selectedTime = TimeOfDay(
                                  hour: task.time.hour,
                                  minute: task.time.minute);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Task'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                              labelText: 'Task Name'),
                                        ),
                                        TextField(
                                          controller: _detailsController,
                                          decoration: InputDecoration(
                                              labelText: 'Task Details'),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedDate == null
                                                    ? 'No date chosen!'
                                                    : 'Picked Date: ${_selectedDate!.toLocal()}'
                                                        .split(' ')[0],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  _selectDate(context),
                                              child: Text('Choose Date'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedTime == null
                                                    ? 'No time chosen!'
                                                    : 'Picked Time: ${_selectedTime!.format(context)}',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  _selectTime(context),
                                              child: Text('Choose Time'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _updateTask(task.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: ListTile(
                            title: Text(task.name),
                            subtitle: Text(task.details),
                            onTap: () => _viewTask(task),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
