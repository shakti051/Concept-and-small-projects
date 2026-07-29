part of 'tasks_bloc.dart';

/// Transient sync status shown in the UI while [SyncPendingTasks] runs.
enum SyncState {
  /// No sync in progress; default resting state.
  idle,

  /// Sync is currently running ([SyncPendingTasks] handler active).
  syncing,

  /// Last sync finished successfully.
  synced,

  /// Last sync threw an error; local data is still intact.
  failed,
}

/// Snapshot of all task lists plus optional sync feedback for the UI.
///
/// Task lists are derived from the flat Hive collection and split into
/// separate buckets so each screen can listen to the slice it needs.
class TasksState extends Equatable {
  /// Active tasks that are not done and not deleted.
  final List<Task> pendingTasks;

  /// Tasks marked as done (`isDone: true`) and not deleted.
  final List<Task> completedTasks;

  /// Subset of tasks flagged as favorite; may overlap pending/completed lists.
  final List<Task> favoriteTasks;

  /// Soft-deleted tasks shown in the recycle bin (`isDeleted: true`).
  final List<Task> removedTasks;

  /// UI state only (DO NOT persist)
  final SyncState syncState;

  /// Human-readable sync result, e.g. "Syncing..." or success/error message.
  final String? syncMessage;

  final Set<String> syncingTaskIds;

   const TasksState({
    this.pendingTasks = const <Task>[],
    this.completedTasks = const <Task>[],
    this.favoriteTasks = const <Task>[],
    this.removedTasks = const <Task>[],
    this.syncingTaskIds = const {},
    this.syncState = SyncState.idle,
    this.syncMessage
  });

   TasksState copyWith({
    List<Task>? pendingTasks,
    List<Task>? completedTasks,
    List<Task>? favoriteTasks,
    List<Task>? removedTasks,
    SyncState? syncState,
     String? syncMessage,
     Set<String>? syncingTaskIds
  }) {
    return TasksState(
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      favoriteTasks: favoriteTasks ?? this.favoriteTasks,
      removedTasks: removedTasks ?? this.removedTasks,
      syncState: syncState ?? this.syncState,
      syncMessage: syncMessage ?? this.syncMessage,
      syncingTaskIds: syncingTaskIds ?? this.syncingTaskIds
    );
  }

  @override
  List<Object> get props => [
    pendingTasks,
    completedTasks,
    favoriteTasks,
    removedTasks,
    syncState,
    syncMessage ?? "",
    syncingTaskIds
  ];

   /// Persist ONLY business data.
  /// UI state should never be hydrated.
  Map<String, dynamic> toMap() {
    return {
      'pendingTasks': pendingTasks.map((x) => x.toMap()).toList(),
      'completedTasks': completedTasks.map((x) => x.toMap()).toList(),
      'favoriteTasks': favoriteTasks.map((x) => x.toMap()).toList(),
      'removedTasks': removedTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      pendingTasks: List<Task>.from(
        map['pendingTasks']?.map((x) => Task.fromMap(x)),
      ),
      completedTasks: List<Task>.from(
        map['completedTasks']?.map((x) => Task.fromMap(x)),
      ),
      favoriteTasks: List<Task>.from(
        map['favoriteTasks']?.map((x) => Task.fromMap(x)),
      ),
      removedTasks: List<Task>.from(
        map['removedTasks']?.map((x) => Task.fromMap(x)),
      ),
     // Never restore UI state from storage.
     syncState: SyncState.idle,
     syncMessage: "" 
    );
  }
}
