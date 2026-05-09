part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  List<Task> allTask;
  List<Task> removeTask;
  TasksState({this.allTask = const <Task>[], this.removeTask = const <Task>[]});

  @override
  List<Object> get props => [allTask, removeTask];

  Map<String, dynamic> toMap() {
    return {
      'allTask': allTask.map((x) => x.toMap()).toList(),
      'removeTask': removeTask.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      allTask: List<Task>.from(map['allTask']?.map((x) => Task.fromMap(x))),
      removeTask: List<Task>.from(map['removeTask']?.map((x) => Task.fromMap(x)))
    );
  }
}
