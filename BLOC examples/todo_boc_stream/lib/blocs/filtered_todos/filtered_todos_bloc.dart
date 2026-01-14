import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../todo_filter/todo_filter_bloc.dart';
import '../todo_list/todo_list_bloc.dart';
import '../todo_search/todo_search_bloc.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;

  final List<Todo> initialTodos;

  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;
  final TodoListBloc todoListBloc;

  FilteredTodosBloc({
    required this.initialTodos,
    required this.todoFilterBloc,
    required this.todoSearchBloc,
    required this.todoListBloc,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription =
        todoFilterBloc.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });

    todoSearchSubscription =
        todoSearchBloc.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });

    todoListSubscription =
        todoListBloc.stream.listen((TodoListState todoListState) {
      setFilteredTodos();
    });

    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
    
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;

    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListBloc.state.todos;
        break;
    }

    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((Todo todo) => todo.desc
              .toLowerCase()
              .contains(todoSearchBloc.state.searchTerm.toLowerCase()))
          .toList();
    }

    add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
