import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task oldTask;

  const EditTaskScreen({
    super.key,
    required this.oldTask,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.oldTask.title,
    );

    descriptionController = TextEditingController(
      text: widget.oldTask.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
        ),
      );
      return;
    }

    // Preserve all existing task properties.
    final editedTask = widget.oldTask.copyWith(
      title: title,
      description: description,
      date: DateTime.now().toIso8601String(),
      lastModified: DateTime.now().toUtc(),
    );

    context.read<TasksBloc>().add(
      EditTask(
        oldTask: widget.oldTask,
        newTask: editedTask,
      ),
    );

    // Do NOT immediately call GetAllTsak().
    //
    // The EditTask handler already does:
    //
    // await repository.update(updatedTask);
    // await emitLatestTasks(emit);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Edit Task',
            style: TextStyle(
              fontSize: 24,
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: const InputDecoration(
                label: Text('Title'),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          TextField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              label: Text('Description'),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),

              ElevatedButton(
                key: const Key('edit_task_save_button'),
                onPressed: _saveTask,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
