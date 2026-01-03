import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_repository/task_repository.dart';
part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc(this.taskRepository) : super(const AddTaskState()) {
    on<ChangeTaskValue>(_changeTaskValue);
    on<ChangeTaskStatus>(_changeTaskStatus);
    on<Submit>(_submit);
    on<SetTaskForEditing>(_setTaskForEditing);
  }

  final TaskRepository taskRepository;

  void _setTaskForEditing(SetTaskForEditing event, Emitter<AddTaskState> emit) {
    final task = event.task;
    if (task == null) return;
    emit(state.copyWith(taskToEdit: task, taskStatus: task.status));
  }

  void _changeTaskValue(ChangeTaskValue event, Emitter<AddTaskState> emit) {
    final newValue = event.task;
    emit(state.copyWith(task: newValue));
  }

  void _changeTaskStatus(ChangeTaskStatus event, Emitter<AddTaskState> emit) {
    final newStatus = event.taskStatus;
    final newState = state.copyWith(taskStatus: newStatus);
    emit(newState);
  }

  void _submit(Submit event, Emitter<AddTaskState> emit) {
    //isloading = true
    emit(state.copyWith(isLoading: true));
    if (state.taskToEdit != null) {
      final updatedTask = Task(
        taskId: state.taskToEdit!.taskId,
        task: state.task,
        status: state.taskStatus,
      );
      taskRepository.editTask(updatedTask);
    } else {
      //add new task
      final taskId = Random().nextInt(100000).toString();
      final newTask =
          Task(taskId: taskId, task: state.task, status: state.taskStatus);
      taskRepository.addTask(newTask);
    }
    //if success emit success state
    emit(state.copyWith(status: FormStatus.success, isLoading: false));
  }
}
