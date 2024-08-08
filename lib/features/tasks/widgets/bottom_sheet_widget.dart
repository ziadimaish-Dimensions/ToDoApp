import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/global/widgets/custom_elevated_button.dart';
import 'package:to_do_app/global/widgets/custom_text_field.dart';
import 'package:to_do_app/global/tasks/task_model.dart';
import 'package:to_do_app/global/tasks/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomSheetWidget extends StatefulWidget {
  final String userId;

  const BottomSheetWidget({required this.userId, super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _dateError;
  String? _timeError;
  final TaskRepository _taskRepository = TaskRepository();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
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
        _dateError = null;
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
        _timeError = null;
      });
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        setState(() {
          _dateError = 'Please choose a date';
        });
        return;
      }
      if (_selectedTime == null) {
        setState(() {
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
        setState(() {
          _dateError = 'Date and time must be in the future or today';
          _timeError = 'Date and time must be in the future or today';
        });
        return;
      }

      final task = TaskModel(
        id: '',
        name: _nameController.text,
        details: _detailsController.text,
        time: dateTime,
        userId: widget.userId,
      );

      _taskRepository.addTask(task);
      _nameController.clear();
      _detailsController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Task Name',
                    hintText: 'Input the task name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    label: 'Task Details',
                    hintText: 'Input the task details',
                    controller: _detailsController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
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
                          await _selectDate(context);
                          setModalState(() {});
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
                  const SizedBox(height: 15),
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
                          await _selectTime(context);
                          setModalState(() {});
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
                  const SizedBox(height: 30),
                  Center(
                    child: CustomElevatedButton(
                      onPressed: _addTask,
                      text: 'Add Task',
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
