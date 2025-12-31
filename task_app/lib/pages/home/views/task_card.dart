import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_repository/task_repository.dart';

import '../../add_pages/add_task_page.dart';
import '../blocs/task/task_bloc_bloc.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(this.task, {super.key});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
           Text(task.task),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (cxt) => AddTaskPage(
                    task: task,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: ()=> context.read<TaskBloc>().add(DeleteTask(task.taskId)),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
