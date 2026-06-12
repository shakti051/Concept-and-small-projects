import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app_firebase/blocs/connectivity/connectivity_bloc.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../bloc_exports.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  ConnectivityBloc connectivityBloc;
  TasksBloc(this.connectivityBloc) : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTsak>(_onGetAllTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
    on<SyncPendingTasks>(_onSyncPendingTasks);
  }
  // sync pending task
  Future<void> _onSyncPendingTasks(
    SyncPendingTasks event,
    Emitter<TasksState> emit,
  ) async {
    for (final task in state.pendingTasks) {
      try {
        await FirestoreRepository.create(task: task);
        debugPrint("Synced: ${task.title}");
      } catch (e) {
        debugPrint("Sync failed: $e");
      }
    }
  }

  void _onAddTask(
  AddTask event,
  Emitter<TasksState> emit,
) async {

  final state = this.state;

  final updatedTasks =
      List<Task>.from(state.pendingTasks)
        ..add(event.task);

  emit(
    TasksState(
      pendingTasks: updatedTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: state.removedTasks,
    ),
  );


  if (connectivityBloc.state.status ==
      ConnectionStatus.online) {

    try {
      final syncedTask = event.task.copyWith(
        syncStatus: SyncStatus.synced,
      );

      await FirestoreRepository.create(
        task: syncedTask,
      );


      final syncedPendingTasks =
          updatedTasks.map((task) {
        return task.id == syncedTask.id
            ? syncedTask
            : task;
      }).toList();


      emit(
        TasksState(
          pendingTasks: syncedPendingTasks,
          completedTasks: state.completedTasks,
          favoriteTasks: state.favoriteTasks,
          removedTasks: state.removedTasks,
        ),
      );

      debugPrint("Task synced");

    } catch (e) {
      debugPrint("Firebase error $e");
    }
  }
}


  void _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    try {
      final remoteTasks = await FirestoreRepository.get();

      // Existing local tasks from HydratedBloc
      final localTasks = [
        ...state.pendingTasks,
        ...state.completedTasks,
        ...state.favoriteTasks,
        ...state.removedTasks,
      ];

      // Merge local + Firebase tasks based on id
      final allTasks = [
        ...localTasks,
        ...remoteTasks.where(
          (remoteTask) =>
              !localTasks.any((localTask) => localTask.id == remoteTask.id),
        ),
      ];

      List<Task> pendingTasks = [];
      List<Task> completedTasks = [];
      List<Task> favoriteTasks = [];
      List<Task> removedTasks = [];

      for (var task in allTasks) {
        if (task.isDeleted == true) {
          removedTasks.add(task);
        } else if (task.isFavorite == true) {
          favoriteTasks.add(task);
        } else if (task.isDone == true) {
          completedTasks.add(task);
        } else {
          pendingTasks.add(task);
        }
      }
      
      emit(
        TasksState(
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
          favoriteTasks: favoriteTasks,
          removedTasks: removedTasks,
        ),
      );
    } catch (e) {
      debugPrint("Get task failed: $e");
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDone: !event.task.isDone!);
    await FirestoreRepository.update(updatedTask);
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await FirestoreRepository.delete(task: event.task);
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    Task removedTask = event.task.copyWith(isDeleted: true);
    await FirestoreRepository.update(removedTask);
  }

  void _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) async {
    Task task = event.task.copyWith(isFavorite: !event.task.isFavorite!);
    await FirestoreRepository.update(task);
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    await FirestoreRepository.update(event.newTask);
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    Task restoreTask = event.task.copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now().toString(),
    );
    await FirestoreRepository.update(restoreTask);
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    await FirestoreRepository.deleteAllRemovedTask(
      taskList: state.removedTasks,
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
