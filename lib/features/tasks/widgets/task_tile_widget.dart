import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/global/tasks/task_model.dart';
import 'package:to_do_app/global/tasks/task_repository.dart';
import 'package:to_do_app/global/widgets/custom_text_field.dart';
import 'package:to_do_app/global/widgets/custom_elevated_button.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;

  TaskTile({required this.task, super.key});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TaskRepository _taskRepository = TaskRepository();

  void _editTask(TaskModel task, BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: task.name);
    final TextEditingController detailsController =
        TextEditingController(text: task.details);
    DateTime selectedDate = task.time;
    TimeOfDay selectedTime =
        TimeOfDay(hour: task.time.hour, minute: task.time.minute);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[600],
          title:
              const Text('Update Task', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: nameController,
                  label: 'Edit Name',
                  hintText: 'Input the task name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: detailsController,
                  label: 'Edit Details',
                  hintText: 'Input the task details',
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
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    final updatedTask = TaskModel(
                      id: task.id,
                      name: nameController.text,
                      details: detailsController.text,
                      time: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                      userId: task.userId,
                    );
                    _taskRepository.updateTask(task.id, updatedTask);
                    Navigator.of(context).pop();
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

  void _viewTask(TaskModel task, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[600],
          title: Text(task.name, style: const TextStyle(color: Colors.white)),
          content:
              Text(task.details, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id),
      background: Container(color: Colors.blue),
      secondaryBackground: Container(color: Colors.red),
      onDismissed: (direction) {
        setState(() {
          _taskRepository.deleteTask(widget.task.id);
        });
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _editTask(widget.task, context);
          return false;
        }
        return true;
      },
      child: ListTile(
        title:
            Text(widget.task.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(widget.task.details,
            style: const TextStyle(color: Colors.white70)),
        onTap: () => _viewTask(widget.task, context),
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
