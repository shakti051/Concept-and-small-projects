part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  List<Task> pendingTask;
  List<Task> completedTask;
  List<Task> favoriteTask;
  List<Task> removeTask;
  TasksState({
    this.pendingTask = const <Task>[],
    this.completedTask = const <Task>[],
    this.favoriteTask = const <Task>[],
    this.removeTask = const <Task>[],
  });

  @override
  List<Object> get props => [
    pendingTask,
    completedTask,
    favoriteTask,
    removeTask,
  ];

  Map<String, dynamic> toMap() {
    return {
      'pendingTask': pendingTask.map((x) => x.toMap()).toList(),
      'completedTask': completedTask.map((x) => x.toMap()).toList(),
      'favoriteTask': favoriteTask.map((x) => x.toMap()).toList(),
      'removeTask': removeTask.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      pendingTask: List<Task>.from(
        map['pendingTask']?.map((x) => Task.fromMap(x)),
      ),
      completedTask: List<Task>.from(
        map['completedTask']?.map((x) => Task.fromMap(x)),
      ),
      favoriteTask: List<Task>.from(
        map['favoriteTask']?.map((x) => Task.fromMap(x)),
      ),
      removeTask: List<Task>.from(
        map['removeTask']?.map((x) => Task.fromMap(x)),
      ),
    );
  }
}
