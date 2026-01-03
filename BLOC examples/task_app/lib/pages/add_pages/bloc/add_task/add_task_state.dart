part of 'add_task_bloc.dart';


enum FormStatus { initial, success, error }

final class AddTaskState extends Equatable {
  const AddTaskState({
    this.task = '',
    this.taskStatus = TaskStatus.todo,
    this.status = FormStatus.initial,
    this.isLoading = false,
    this.taskToEdit,
  });

  final FormStatus status;
  final TaskStatus taskStatus;
  final String task;
  final bool isLoading;
  final Task? taskToEdit;

  AddTaskState copyWith({
    FormStatus? status,
    TaskStatus? taskStatus,
    String? task,
    bool? isLoading,
    Task? taskToEdit,
  }) {
    return AddTaskState(
      task: task ?? this.task,
      taskStatus: taskStatus ?? this.taskStatus,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      taskToEdit: taskToEdit ?? this.taskToEdit,
    );
  }

  @override
  List<Object?> get props => [
        task,
        taskStatus,
        status,
        isLoading,
        taskToEdit,
      ];
}
