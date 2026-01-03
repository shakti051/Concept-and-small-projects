import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_repository/task_repository.dart';
part 'task_bloc_event.dart';
part 'task_bloc_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this.taskRepository) : super(const TaskState(tasks: [])) {
    on<SetAllTasks>(_getAllTasks);
    on<SelectCategory>(_selectCategory);
    on<DeleteTask>(_deleteTodo);
    //listen to task stream from task repository
    taskRepository.allTodos.listen((todosList) {
      add(SetAllTasks(todosList));
    });

  }

  final TaskRepository taskRepository;
  //callback for SetAllTasks event
  void _getAllTasks(SetAllTasks event, Emitter<TaskState> emit) {
    //we get the new list of tasks
    final newTaskList = event.tasks;
    //doesnt change the selected cateogry value
   final newState = state.copyWith(tasks: newTaskList);
   emit(newState);
   // emit(TaskState(tasks: newTaskList));
  }

  //callback for SelectCategory event
  void _selectCategory(SelectCategory event, Emitter<TaskState> emit) {
    //get the category from event props
    final newCategory = event.category;
    //get newstate using new category from copywith method
    final newState = state.copyWith(tasks: state.tasks, selectedCategory: newCategory);
    //emit new state
    emit(newState);
   // emit(TaskState(tasks: state.tasks,selectedCategory: newCategory));
  }
  void _deleteTodo(DeleteTask event, Emitter<TaskState> emit) {
    //get the category from event props
    taskRepository.deleteTask(event.taskId);
   // emit(TaskState(tasks: state.tasks,selectedCategory: newCategory));
  }
}
