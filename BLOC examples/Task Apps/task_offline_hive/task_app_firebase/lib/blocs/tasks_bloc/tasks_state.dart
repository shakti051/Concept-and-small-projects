part of 'tasks_bloc.dart';

enum SyncState { idle, syncing, synced, failed }

class TasksState extends Equatable {
  final List<Task> pendingTasks;
  final List<Task> completedTasks;
  final List<Task> favoriteTasks;
  final List<Task> removedTasks;

  /// UI state only (DO NOT persist)
  final SyncState syncState;
  final String? syncMessage;
   const TasksState({
    this.pendingTasks = const <Task>[],
    this.completedTasks = const <Task>[],
    this.favoriteTasks = const <Task>[],
    this.removedTasks = const <Task>[],
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
  }) {
    return TasksState(
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      favoriteTasks: favoriteTasks ?? this.favoriteTasks,
      removedTasks: removedTasks ?? this.removedTasks,
      syncState: syncState ?? this.syncState,
      syncMessage: syncMessage ?? this.syncMessage
    );
  }

  @override
  List<Object> get props => [
    pendingTasks,
    completedTasks,
    favoriteTasks,
    removedTasks,
    syncState,
    syncMessage ?? ""
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
