part of 'task_bloc_bloc.dart';

final class TaskState {
  const TaskState({
    required this.tasks,
    this.selectedCategory = TaskCategory.all,
  });

  //state variables
  final TaskCategory selectedCategory;
  final List<Task> tasks;

  //what does this function do?
  //it gets tasks list and selected category as optional parameters
  //if the parameters are given create a new TaskState object with that values
  //otherwise create a TaskState object with existing values
  TaskState copyWith({List<Task>? tasks, TaskCategory? selectedCategory}) =>
      TaskState(
        tasks: tasks ?? this.tasks,
        selectedCategory: selectedCategory ?? this.selectedCategory,
      );
}
