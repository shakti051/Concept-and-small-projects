import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../todo_list/todo_list_cubit.dart';
import 'active_todo_count__state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  final int initialActiveTodoCount;

  ActiveTodoCountCubit({required this.initialActiveTodoCount})
  : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount));

   void calculateActiveTodoCount(int activeTodoCount) {
    emit(state.copyWith(activeTodoCount: activeTodoCount));
  }
}
