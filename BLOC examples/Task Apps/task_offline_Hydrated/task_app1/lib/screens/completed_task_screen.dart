
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/tasks/tasks_bloc.dart';
import '../models/task.dart';
import '../widgets/tasks_list.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  static const id = "completed_task_id";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.completedTask;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Chip(label: Text('${tasksList.length} Tasks:'))),
            TasksList(tasksList: tasksList),
          ],
        );
      },
    );
  }
}
