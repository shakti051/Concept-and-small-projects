import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/pages/home/blocs/task/task_bloc_bloc.dart';
import 'package:task_repository/task_repository.dart';
import '../../../locator.dart';
import 'category_card.dart';
import 'fab.dart';
import 'selected_categories.dart';
import 'selected_todos_list.dart';
import 'task_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(lc<TaskRepository>()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FAB(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: ListView(
          children: const [
            Row(children: [
              Expanded(child: CategoryCard(TaskCategory.done)),
              Expanded(child: CategoryCard(TaskCategory.pending))
            ]),
            CategoryCard(TaskCategory.todo),
            SizedBox(height: 20),
            SelectedCategory(),
            SizedBox(height: 20),
            SelectedTodosList(),
          ]
        ),
      ),
    );
  }
}
