import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app_firebase/services/locator.dart';
import 'package:uuid/uuid.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Add Task', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();

                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    throw Exception('User is not logged in');
                  }

                  final task = Task(
                    title: title,
                    description: description,
                    id: getIt<Uuid>().v4(),
                    date: DateTime.now().toIso8601String(),
                    syncStatus: SyncStatus.pendingCreate,
                    lastModified: DateTime.now().toUtc(),
                    ownerId: user.uid, // NEW
                  );

                  context.read<TasksBloc>().add(AddTask(task: task));
                  //context.read<TasksBloc>().add(GetAllTsak());
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
