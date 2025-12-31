import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/locator.dart';
import 'package:task_app/pages/add_pages/bloc/add_task/add_task_bloc.dart';
import 'package:task_repository/task_repository.dart';
import 'status_card.dart';
import 'submit_btn.dart';
import 'text_input.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({this.task ,super.key});
  final Task? task;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskBloc(lc())..add(SetTaskForEditing(widget.task)),
      lazy: true,
      child: BlocListener<AddTaskBloc, AddTaskState>(
        listener: (context, state) {
          // TODO: implement listener
        if (state.status == FormStatus.success) {
          Navigator.pop(context);
        }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                 TextInput(task: widget.task,),
                const SizedBox(height: 40),
                Row(children: [
                  StatusCard(status: TaskStatus.todo),
                  StatusCard(status: TaskStatus.pending),
                  StatusCard(status: TaskStatus.done),
                ]),
                const SizedBox(height: 40),
                const SubmitBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
