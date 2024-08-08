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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _dateError;
  String? _timeError;
  String? _selectedCategory;
  String? _categoryError;

  final List<String> _categories = ['Work', 'School', 'University', 'Personal'];

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _selectedDate = _task.time;
    _selectedTime = TimeOfDay(hour: _task.time.hour, minute: _task.time.minute);
    _selectedCategory = _task.category;
  }

  void _editTask(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: _task.name);
    final TextEditingController detailsController =
        TextEditingController(text: _task.details);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.grey[600],
              title: const Text('Update Task',
                  style: TextStyle(color: Colors.white)),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No date chosen!'
                                  : 'Picked Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setModalState(() {
                                  _selectedDate = picked;
                                  _dateError = null;
                                });
                              }
                            },
                            child: const Text('Choose Date'),
                          ),
                        ],
                      ),
                      if (_dateError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _dateError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedTime == null
                                  ? 'No time chosen!'
                                  : 'Picked Time: ${_selectedTime!.format(context)}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime ?? TimeOfDay.now(),
                              );
                              if (picked != null && picked != _selectedTime) {
                                setModalState(() {
                                  _selectedTime = picked;
                                  _timeError = null;
                                });
                              }
                            },
                            child: const Text('Choose Time'),
                          ),
                        ],
                      ),
                      if (_timeError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _timeError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setModalState(() {
                            _selectedCategory = newValue;
                            _categoryError = null;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        dropdownColor: Colors.grey[800],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a category';
                          }
                          return null;
                        },
                      ),
                      if (_categoryError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _categoryError!,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                          if (_selectedDate == null) {
                            setModalState(() {
                              _dateError = 'Please choose a date';
                            });
                            return;
                          }
                          if (_selectedTime == null) {
                            setModalState(() {
                              _timeError = 'Please choose a time';
                            });
                            return;
                          }

                          final dateTime = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );
                          if (dateTime.isBefore(DateTime.now())) {
                            setModalState(() {
                              _dateError =
                                  'Date and time must be in the future or today';
                              _timeError =
                                  'Date and time must be in the future or today';
                            });
                            return;
                          }

                          if (_selectedCategory == null ||
                              _selectedCategory!.isEmpty) {
                            setModalState(() {
                              _categoryError = 'Please choose a category';
                            });
                            return;
                          }

                          final updatedTask = TaskModel(
                            id: _task.id,
                            name: nameController.text,
                            details: detailsController.text,
                            time: dateTime,
                            userId: _task.userId,
                            category: _selectedCategory!,
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
                                  _taskRepository.updateTask(
                                      _task.id, widget.task);
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
      },
    );
  }

  void _deleteTask(BuildContext context) {
    _taskRepository.deleteTask(_task.id, _task.name);
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.circle_outlined, color: Colors.white),
              title: Text(
                _task.name,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
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
                const Text(
                  'Task Time:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd – kk:mm').format(_task.time),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.white70),
                const SizedBox(width: 10),
                const Text('Task Category: ',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _task.category,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
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
