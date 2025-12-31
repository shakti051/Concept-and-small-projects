part of 'add_task_bloc.dart';

@immutable
sealed class AddTaskEvent {}

final class ChangeTaskValue extends AddTaskEvent {
  ChangeTaskValue(this.task);
  final String task;
}

final class ChangeTaskStatus extends AddTaskEvent {
  ChangeTaskStatus(this.taskStatus);
  final TaskStatus taskStatus;
}

final class Submit extends AddTaskEvent {}

final class SetTaskForEditing extends AddTaskEvent {
  SetTaskForEditing(this.task);
  final Task? task;
}

