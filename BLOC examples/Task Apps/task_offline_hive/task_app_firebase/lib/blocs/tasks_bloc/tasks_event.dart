part of 'tasks_bloc.dart';

/// Base class for all user actions and lifecycle triggers handled by [TasksBloc].
abstract class TasksEvent extends Equatable {
  const TasksEvent();
  @override
  List<Object> get props => [];
}

/// Saves a new task to local storage and adds it to [TasksState.pendingTasks].
/// Marks the task as [SyncStatus.pendingCreate] and triggers sync when online.
class AddTask extends TasksEvent {
  final Task task;
  const AddTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Loads every task from the local Hive repository and rebuilds all list views.
/// Dispatched on app start; also kicks off background sync when online.
class GetAllTsak extends TasksEvent {
  @override
  List<Object> get props => [];
}

/// Toggles a task between pending and completed (`isDone` is flipped).
/// Keeps [SyncStatus.pendingCreate] for unsynced tasks; otherwise marks
/// [SyncStatus.pendingUpdate] before persisting and syncing.
class UpdateTask extends TasksEvent {
  final Task task;
  const UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Soft-deletes a task by moving it to [TasksState.removedTasks] (recycle bin).
/// Sets `isDeleted: true` locally; does not permanently erase the record yet.
class RemoveTask extends TasksEvent {
  final Task task;
  const RemoveTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Permanently removes a task from the recycle bin.
/// If the task never reached Firebase, it is deleted from Hive immediately;
/// otherwise it is marked [SyncStatus.pendingHardDelete] until sync completes.
class DeleteTask extends TasksEvent {
  final Task task;
  const DeleteTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Toggles the favorite flag on a task and updates [TasksState.favoriteTasks].
class MarkFavoriteOrUnfavoriteTask extends TasksEvent {
  final Task task;
  const MarkFavoriteOrUnfavoriteTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Replaces an existing task with edited fields (title, description, date, etc.).
/// [oldTask] identifies the record; [newTask] carries the updated values.
class EditTask extends TasksEvent {
  final Task oldTask;
  final Task newTask;
  const EditTask({required this.oldTask, required this.newTask});

  @override
  List<Object> get props => [
    //     oldTask,
    newTask,
  ];
}

/// Restores a soft-deleted task from the recycle bin back to pending.
/// Resets `isDeleted`, `isDone`, and `isFavorite`, then saves locally.
class RestoreTask extends TasksEvent {
  final Task task;
  const RestoreTask({required this.task});

  @override
  List<Object> get props => [task];
}

/// Empties the entire recycle bin: clears UI immediately, then deletes or
/// hard-deletes each removed task depending on its sync status.
class DeleteAllTasks extends TasksEvent {}

/// Pushes local changes to Firestore and pulls remote updates.
/// Updates [TasksState.syncState] and [TasksState.syncMessage] for UI feedback.
/// [isManual] distinguishes user-initiated sync from automatic background sync.
class SyncPendingTasks extends TasksEvent {
  final bool isManual;

  const SyncPendingTasks({this.isManual = false});
}
