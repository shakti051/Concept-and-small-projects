import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';
import 'popup_menu.dart';


class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  void _removeOrDeleteTask(BuildContext context) {
    if (task.isDeleted) {
      context.read<TasksBloc>().add(DeleteTask(task: task));
    } else {
      context.read<TasksBloc>().add(RemoveTask(task: task));
    }
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditTaskScreen(oldTask: task),
        ),
      ),
    );
  }
  
  Widget _buildSyncIndicator(bool isSyncing) {
    if (isSyncing) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
    switch (task.syncStatus) {
      case SyncStatus.synced:
        return const Icon(Icons.cloud_done, color: Colors.green, size: 18);
      case SyncStatus.pendingCreate:
      case SyncStatus.pendingUpdate:
        return const Icon(
          Icons.cloud_upload_outlined,
          color: Colors.orange,
          size: 18,
        );

      case SyncStatus.pendingHardDelete:
        return const Icon(Icons.delete_outline, color: Colors.red, size: 18);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reserved for future per-task syncing
     final state = context.watch<TasksBloc>().state;
     final isSyncing = state.syncingTaskIds.contains(task.id);

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                task.isFavorite
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_outline),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _buildSyncIndicator(isSyncing),
                        ],
                      ),
                      Text(
                        DateFormat().add_yMMMd().add_Hms().format(
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
                onChanged: task.isDeleted
                    ? null
                    : (_) {
                        context.read<TasksBloc>().add(UpdateTask(task: task));
                      },
              ),
              PopupMenu(
                task: task,
                cancelOrDeleteCallback: () => _removeOrDeleteTask(context),
                likeOrDislikeCallback: () {
                  context.read<TasksBloc>().add(
                    MarkFavoriteOrUnfavoriteTask(task: task),
                  );
                },
                editTaskCallback: () {
                  Navigator.of(context).pop();
                  _editTask(context);
                },
                restoreTaskCallback: () {
                  context.read<TasksBloc>().add(RestoreTask(task: task));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
