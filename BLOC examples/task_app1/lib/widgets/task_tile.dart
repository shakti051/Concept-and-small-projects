import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
  });

  final Task task;
   void _removeOrDeleteTask(BuildContext ctx,Task task){
    task.isDeleted! ? ctx.read<TasksBloc>().add(DeleteTask(task: task)):
    ctx.read<TasksBloc>().add(RemoveTask(task: task));
   }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: task.isDone! ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: task.isDone,
        onChanged: task.isDeleted == false ? (value) {
          context.read<TasksBloc>().add(UpdateTask(task: task));
        }:null,
      ),
      onLongPress: () =>
          _removeOrDeleteTask(context,task),
    );
  }
}
