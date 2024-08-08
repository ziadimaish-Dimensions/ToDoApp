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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
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
    Navigator.pop(context);
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
                top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                    label: 'Task Name',
                    hintText: 'Input the task name',
                    controller: _nameController),
                const SizedBox(height: 30),
                CustomTextField(
                    label: 'Task Details',
                    hintText: 'Input the task details',
                    controller: _detailsController),
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
        );
      },
    );
  }
}
