import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app1/blocs/blocs.dart';
import 'package:task_app1/widgets/tasks_list.dart';
import 'my_drawer.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});
  static const id = "recycle_bin";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tasks App'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              PopupMenuButton(itemBuilder:(context)=>[
                PopupMenuItem(
                onTap:()=> context.read<TasksBloc>().add(DeleteAllTask()),
                child: TextButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete_forever),
                  label: Text("Delete All"),
                ),
              ),
              ] )
            ],
          ),
          drawer: MyDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Center(child: Chip(label: Text('${state.removeTask.length} Tasks:'))),
              TasksList(tasksList: state.removeTask),
            ],
          ),
        );
      },
    );
  }
}
