import 'package:equatable/equatable.dart';
import '../../models/task.dart';
import '../../respository/firestore_repository.dart';
import '../bloc_exports.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<GetAllTsak>(_onGetAllTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    FirestoreRepository.create(task: event.task);
  }

  void _onGetAllTask(GetAllTsak event, Emitter<TasksState> emit) async {
    List<Task> pendingTask = [];
    List<Task> completedTask = [];
    List<Task> favoriteTask = [];
    List<Task> removedTask = [];

    await FirestoreRepository.get().then((value) {
      for (var task in value) {
        if (task.isDeleted == true) {
          removedTask.add(task);
        } else if (task.isFavorite == true) {
          favoriteTask.add(task);
        } else if (task.isDone == true) {
          completedTask.add(task);
        } else {
          pendingTask.add(task);
        }
      }
    });
    emit(
      TasksState(
        pendingTasks: pendingTask,
        completedTasks: completedTask,
        favoriteTasks: favoriteTask,
        removedTasks: removedTask,
      ),
    );
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    Task updatedTask = event.task.copyWith(isDone: !event.task.isDone!);
    await FirestoreRepository.update(updatedTask);
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async{
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

  void _onEditTask(EditTask event, Emitter<TasksState> emit) async{
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

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) async{
    await FirestoreRepository.deleteAllRemovedTask(taskList: state.removedTasks);
  }
}
