import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/add_task/add_task_bloc.dart';

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        child: GestureDetector(
      onTap: () => context.read<AddTaskBloc>().add(Submit()),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: BlocBuilder<AddTaskBloc, AddTaskState>(
            builder: (context, state) {
              return Text(
                state.taskToEdit != null ? 'Edit task' : 'Add new todo',
                style:const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    ));
  }
}
