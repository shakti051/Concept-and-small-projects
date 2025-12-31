import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/pages/home/views/home.dart';
import 'package:task_app/pages/home/views/selected_categories.dart';
import 'package:task_repository/task_repository.dart';
import '../../../locator.dart';
import '../blocs/task/task_bloc_bloc.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
    this.cat, {
    super.key,
  });
  final TaskCategory cat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newEvent = SelectCategory(cat);
        context.read<TaskBloc>().add(newEvent);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: lc<TaskRepository>().getColorForCategory(cat),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: BlocBuilder<TaskBloc, TaskState>(  
            builder: (context, state) {
              int amount =0;
              final taskList = state.tasks;
              amount = lc<TaskRepository>()
                  .getLengthOfTasksForCategory(cat, taskList);
              return Text(
                lc<TaskRepository>().getTextForCategory(cat, amount),
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
