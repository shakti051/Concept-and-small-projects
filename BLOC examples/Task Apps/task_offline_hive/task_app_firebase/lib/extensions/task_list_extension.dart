import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../models/task.dart';

extension TaskListExtension on List<Task> {
  
  TasksState toTasksState({
    SyncState syncState = SyncState.idle,
  }) {
    final pendingTasks = <Task>[];
    final completedTasks = <Task>[];
    final favoriteTasks = <Task>[];
    final removedTasks = <Task>[];

    for (final task in this) {
      if (task.isDeleted) {
        removedTasks.add(task);
        continue;
      }

      if (task.isDone) {
        completedTasks.add(task);
      } else {
        pendingTasks.add(task);
      }

      if (task.isFavorite) {
        favoriteTasks.add(task);
      }
    }

    return TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: removedTasks,
      syncState: syncState,
    );
  }

  void replace(Task task) {
    final index = indexWhere((t) => t.id == task.id);

    if (index != -1) {
      this[index] = task;
    }
  }

  void updateFavorite(Task task) {
    if (task.isFavorite) {
      if (!any((t) => t.id == task.id)) {
        insert(0, task);
      } else {
        replace(task);
      }
    } else {
      removeWhere((t) => t.id == task.id);
    }
  }

}