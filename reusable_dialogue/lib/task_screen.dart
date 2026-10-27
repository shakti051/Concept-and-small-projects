import 'package:flutter/material.dart';

import 'async_dialogue.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  final _titleController = TextEditingController();

  Future<void> _saveTask() async {
    // Replace with your repository/API/Firebase operation.
    await Future.delayed(const Duration(seconds: 2));

    if (_titleController.text.trim() == 'error') {
      throw Exception('Failed to save task');
    }

    debugPrint('Saved: ${_titleController.text}');
  }

  Future<void> _openAddTaskDialog(BuildContext context) async {
    _titleController.clear();

    final result = await showAsyncAppDialog(
      context: context,
      title: 'Add Task',
      confirmText: 'Save',
      cancelText: 'Cancel',

      contentBuilder: (context, formKey) {
        return TextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task title',
            hintText: 'Enter task title',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Task title is required';
            }

            if (value.trim().length < 3) {
              return 'Enter at least 3 characters';
            }

            return null;
          },
        );
      },

      onConfirm: _saveTask,
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openAddTaskDialog(context),
          child: const Text('Add Task'),
        ),
      ),
    );
  }
}
