import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/pages/home/blocs/task/task_bloc_bloc.dart';
import 'package:task_repository/task_repository.dart';

class SelectedCategory extends StatelessWidget {
  const SelectedCategory({super.key});

  String _getText(TaskCategory category) {
    switch (category) {
      case TaskCategory.all:
        return 'All Tasks';
      case TaskCategory.done:
        return 'Done Tasks';
      case TaskCategory.pending:
        return 'Pending Tasks';
      case TaskCategory.todo:
        return 'Todos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final selectedCategory = state.selectedCategory;
          return Text(
            _getText(selectedCategory),
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
