import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/pages/home/blocs/task/task_bloc_bloc.dart';
import 'package:task_repository/task_repository.dart';
import 'task_card.dart';

class SelectedTodosList extends StatelessWidget {
  const SelectedTodosList({super.key});

  List<Task> getTasksForCategory(List<Task> allTasks, TaskCategory cat) {
    List<Task> filtered = [];
    for (var t in allTasks) {
      if (cat == TaskCategory.all) {
        filtered.add(t);
      } else if (cat == TaskCategory.done) {
        if (t.status == TaskStatus.done) {
          filtered.add(t);
        }
      } else if (cat == TaskCategory.pending) {
        if (t.status == TaskStatus.pending) {
          filtered.add(t);
        }
      } else if (cat == TaskCategory.todo) {
        if (t.status == TaskStatus.todo) {
          filtered.add(t);
        }
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final selectedCategory = state.selectedCategory;
        final allTasks = state.tasks;
        final filteredList = getTasksForCategory(allTasks, selectedCategory);

        if (filteredList.isEmpty) {
          return const Center(
            child: Text('No todos yet!'),
          );
        }

        return Column(
          children: filteredList
              .map(
                (e) => TaskCard(e),
              )
              .toList(),
        );
      },
    );
  }
}
