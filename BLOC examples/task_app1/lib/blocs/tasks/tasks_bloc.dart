import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_app1/blocs/blocs.dart';
import 'package:task_app1/models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTask>(_onDeleteAllTask);
  }

  
  void _onDeleteAllTask(DeleteAllTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removeTask: List.from(state.removeTask)..clear(),
        pendingTask: state.pendingTask,
        completedTask: state.completedTask,
        favoriteTask: state.favoriteTask,
      ),
    );
  }


  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removeTask: List.from(state.removeTask)..remove(event.task),
        pendingTask: List.from(state.pendingTask)
          ..insert(
              0,
              event.task.copyWith(
                isDeleted: false,
                isDone: false,
                isFavorite: false,
              )),
        completedTask: state.completedTask,
        favoriteTask: state.favoriteTask,
      ),
    );
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> favouriteTasks = state.favoriteTask;
    if (event.oldTask.isFavorite == true) {
      favouriteTasks
        ..remove(event.oldTask)
        ..insert(0, event.newTask);
    }

    emit(
      TasksState(
        pendingTask: List.from(state.pendingTask)
          ..remove(event.oldTask)
          ..insert(0, event.newTask),
        completedTask: state.completedTask..remove(event.oldTask),
        favoriteTask: favouriteTasks,
        removeTask: state.removeTask,
      ),
    );
  }

  void _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) {
    final state = this.state;
    List<Task> pendingTasks = state.pendingTask;
    List<Task> completedTasks = state.completedTask;
    List<Task> favoriteTasks = state.favoriteTask;
    if (event.task.isDone == false) {
      if (event.task.isFavorite == false) {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.remove(event.task);
      }
    } else {
      if (event.task.isFavorite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.remove(event.task);
      }
    }
    emit(
      TasksState(
        pendingTask: pendingTasks,
        completedTask: completedTasks,
        favoriteTask: favoriteTasks,
        removeTask: state.removeTask,
      ),
    );
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        pendingTask: List.from(state.pendingTask)..add(event.task),
        completedTask: state.completedTask,
        favoriteTask: state.favoriteTask,
        removeTask: state.removeTask,
      ),
    );
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    /// final int index = state.pendingTask.indexOf(task);
    List<Task> pendingTask = state.pendingTask;
    List<Task> completedTask = state.completedTask;
    task.isDone == false
        ? {
            pendingTask = List.from(pendingTask)..remove(task),
            completedTask = List.from(completedTask)
              ..insert(0, task.copyWith(isDone: true)),
          }
        : {
            completedTask = List.from(completedTask)..remove(task),
            pendingTask = List.from(pendingTask)
              ..insert(0, task.copyWith(isDone: false)),
          };
    emit(
      TasksState(
        pendingTask: pendingTask,
        completedTask: completedTask,
        favoriteTask: state.favoriteTask,
        removeTask: state.removeTask,
      ),
    );
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        pendingTask: List.from(state.pendingTask)..remove(event.task),
        completedTask: List.from(state.completedTask)..remove(event.task),
        favoriteTask: List.from(state.favoriteTask)..remove(event.task),
        removeTask: List.from(state.removeTask)
          ..add(event.task.copyWith(isDeleted: true)),
      ),
    );
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        pendingTask: state.pendingTask,
        completedTask: state.completedTask,
        favoriteTask: state.favoriteTask,
        removeTask: List.from(state.removeTask)..remove(event.task),
      ),
    );
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
