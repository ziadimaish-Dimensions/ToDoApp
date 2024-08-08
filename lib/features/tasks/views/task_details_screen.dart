import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/global/tasks/task_model.dart';
import 'package:to_do_app/global/tasks/task_repository.dart';
import 'package:to_do_app/global/widgets/custom_text_field.dart';
import 'package:to_do_app/global/widgets/custom_elevated_button.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({required this.task, super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  late TaskModel _task;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  void _editTask(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: _task.name);
    final TextEditingController detailsController =
        TextEditingController(text: _task.details);
    DateTime selectedDate = _task.time;
    TimeOfDay selectedTime =
        TimeOfDay(hour: _task.time.hour, minute: _task.time.minute);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[600],
          title:
              const Text('Update Task', style: TextStyle(color: Colors.white)),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: nameController,
                    label: 'Edit Name',
                    hintText: 'Input the task name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: detailsController,
                    label: 'Edit Details',
                    hintText: 'Input the task details',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _DatePicker(
                    selectedDate: selectedDate,
                    onDatePicked: (date) {
                      selectedDate = date;
                    },
                  ),
                  const SizedBox(height: 10),
                  _TimePicker(
                    selectedTime: selectedTime,
                    onTimePicked: (time) {
                      selectedTime = time;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedTask = TaskModel(
                        id: _task.id,
                        name: nameController.text,
                        details: detailsController.text,
                        time: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        userId: _task.userId,
                      );
                      _taskRepository.updateTask(_task.id, updatedTask);
                      setState(() {
                        _task = updatedTask;
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Task updated successfully'),
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              setState(() {
                                _task = widget.task;
                              });
                              _taskRepository.updateTask(_task.id, widget.task);
                            },
                          ),
                        ),
                      );
                    }
                  },
                  text: 'Update',
                ),
                const SizedBox(width: 8),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Cancel',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(BuildContext context) {
    _taskRepository.deleteTask(_task.id);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted successfully'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            _taskRepository.addTask(_task);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editTask(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _task.name,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _task.details,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70),
                const SizedBox(width: 10),
                Text(
                  'Task Time: ${DateFormat('yyyy-MM-dd – kk:mm').format(_task.time)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Icon(Icons.category, color: Colors.white70),
                SizedBox(width: 10),
                Text(
                  'Task Category: University',
                  // You can replace this with dynamic category
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Center(
              child: CustomElevatedButton(
                onPressed: () => _deleteTask(context),
                text: 'Delete Task',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDatePicked;

  const _DatePicker(
      {required this.selectedDate, required this.onDatePicked, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Picked Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              onDatePicked(picked);
            }
          },
          child:
              const Text('Choose Date', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _TimePicker extends StatelessWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimePicked;

  const _TimePicker(
      {required this.selectedTime, required this.onTimePicked, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Picked Time: ${selectedTime.format(context)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (picked != null) {
              onTimePicked(picked);
            }
          },
          child:
              const Text('Choose Time', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
