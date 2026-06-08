import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app1/blocs/blocs.dart';
import 'package:task_app1/models/task.dart';
import 'package:task_app1/screens/add_task_screen.dart';
import 'package:task_app1/screens/my_drawer.dart';
import 'package:task_app1/widgets/tasks_list.dart';

class PendingTaskScreen extends StatelessWidget {
  const PendingTaskScreen({super.key});
  static const id = "Pending_task_id";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.pendingTask;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                label: Text(
                  '${state.pendingTask.length}Pending | ${state.completedTask.length} completed',
                ),
              ),
            ),
            TasksList(tasksList: tasksList),
          ],
        );
      },
    );
  }
}
