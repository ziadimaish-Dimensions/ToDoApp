import 'package:flutter/material.dart';
import 'package:to_do_app/features/tasks/widgets/bottom_sheet_widget.dart';

/// The `AddTaskWidget` displays a floating action button that opens a bottom sheet
/// for adding a new task when pressed.

class AddTaskWidget extends StatelessWidget {
  final String userId;

  const AddTaskWidget({required this.userId, super.key});

  /// Displays the bottom sheet for adding a new task.
  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BottomSheetWidget(userId: userId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddTaskBottomSheet(context),
      backgroundColor: const Color(0xFF8875FF),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
