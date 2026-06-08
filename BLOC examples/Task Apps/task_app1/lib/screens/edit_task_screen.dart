import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app1/blocs/tasks/tasks_bloc.dart';
import 'package:task_app1/models/task.dart';
import 'package:task_app1/services/guid_gen.dart';

class EditTaskScreen extends StatelessWidget {
  final Task oldTask;
  const EditTaskScreen({super.key, required this.oldTask});

  //   @override
  //   State<EditTaskScreen> createState() => _AddTaskScreenState();
  // }

  // class _AddTaskScreenState extends State<EditTaskScreen> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: oldTask.title,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: oldTask.description,
    );

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Edit Task", style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                label: Text("Title"),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text("Description"),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  var editTask = Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    date: DateTime.now().toString(),
                    id: oldTask.id,
                    isFavorite: oldTask.isFavorite,
                    isDone: false,
                  );
                  context.read<TasksBloc>().add(
                    EditTask(oldTask: oldTask, newTask: editTask),
                  );
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
