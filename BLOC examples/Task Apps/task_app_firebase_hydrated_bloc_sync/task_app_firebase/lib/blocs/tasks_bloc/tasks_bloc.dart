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

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final updatedTasks = List<Task>.from(state.pendingTasks)..add(event.task);

    emit(
      TasksState(
        pendingTasks: updatedTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        final syncedTask = event.task.copyWith(syncStatus: SyncStatus.synced);

        await FirestoreRepository.create(task: syncedTask);

        final syncedPendingTasks = updatedTasks.map((task) {
          return task.id == syncedTask.id ? syncedTask : task;
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
    final state = this.state;

    // Remove locally first
    final updatedRemovedTasks = List<Task>.from(state.removedTasks)
      ..remove(event.task);

    emit(
      TasksState(
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: updatedRemovedTasks,
      ),
    );
    debugPrint("Delete event received for ${event.task.id}");
    debugPrint("Connection Status: ${connectivityBloc.state.status}");
    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.delete(task: event.task);

        debugPrint("${event.task.title} deleted from Firebase");
      } catch (e) {
        debugPrint("Delete failed: $e");
      }
    }
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) async {
    final removedTask = event.task.copyWith(isDeleted: true);

    final updatedPendingTasks = List<Task>.from(state.pendingTasks)
      ..remove(event.task);

    final updatedRemovedTasks = List<Task>.from(state.removedTasks)
      ..add(removedTask);

    emit(
      TasksState(
        pendingTasks: updatedPendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
        removedTasks: updatedRemovedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(removedTask);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _onMarkFavoriteOrUnfavoriteTask(
    MarkFavoriteOrUnfavoriteTask event,
    Emitter<TasksState> emit,
  ) async {
    final state = this.state;
    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favoriteTasks = state.favoriteTasks;
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
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favoriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        Task task = event.task.copyWith(isFavorite: !event.task.isFavorite!);
        await FirestoreRepository.update(task);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async {
    final state = this.state;

    final pendingTasks = List<Task>.from(state.pendingTasks);

    final completedTasks = List<Task>.from(state.completedTasks);

    final favouriteTasks = List<Task>.from(state.favoriteTasks);

    if (pendingTasks.remove(event.oldTask)) {
      pendingTasks.insert(0, event.newTask);
    }

    if (completedTasks.remove(event.oldTask)) {
      completedTasks.insert(0, event.newTask);
    }

    if (favouriteTasks.remove(event.oldTask)) {
      favouriteTasks.insert(0, event.newTask);
    }

    emit(
      TasksState(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        favoriteTasks: favouriteTasks,
        removedTasks: state.removedTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(event.newTask);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) async {
    final state = this.state;
    Task restoreTask = event.task.copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now().toString(),
    );

    emit(
      TasksState(
        removedTasks: List.from(state.removedTasks)..remove(event.task),
        pendingTasks: List.from(state.pendingTasks)..insert(0, restoreTask),
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.update(restoreTask);
      } catch (e) {
        debugPrint("Restore failed: $e");
      }
    }
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async {
    final state = this.state;
    final tasksToDelete = List<Task>.from(state.removedTasks);

    emit(
      TasksState(
        removedTasks: const [], // List.from(state.removedTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );

    if (connectivityBloc.state.status == ConnectionStatus.online) {
      try {
        await FirestoreRepository.deleteAllRemovedTask(taskList: tasksToDelete);
      } catch (e) {
        debugPrint("Restore failed: $e");
      }
    }
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
