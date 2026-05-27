import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app1/screens/edit_task_screen.dart';
import '../blocs/blocs.dart';
import '../models/task.dart';
import 'popup_menu.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;
  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDeleted!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditTaskScreen(oldTask: task),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                task.isFavorite == false
                    ? Icon(Icons.star_outline)
                    : Icon(Icons.star),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: task.isDone!
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        DateFormat().add_yMEd().add_Hms().format(
                          DateTime.parse(task.date),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: task.isDone,
                onChanged: task.isDeleted == false
                    ? (value) {
                        context.read<TasksBloc>().add(UpdateTask(task: task));
                      }
                    : null,
              ),
              PopUpMenu(
                task: task,
                restoreCallBack: ()=>context.read<TasksBloc>().add(RestoreTask(task: task)),
                editVoidCallback: () {
                  Navigator.of(context).pop();
                  _editTask(context);
                },
                likeOrDislike: () => context.read<TasksBloc>().add(
                  MarkFavoriteOrUnfavoriteTask(task: task),
                ),
                cancelOrDeleteCallBack: () =>
                    _removeOrDeleteTask(context, task),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

