import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_repository/task_repository.dart';

import 'bloc/add_task/add_task_bloc.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    this.task,
    super.key,
  });

  final Task? task;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _controller.text = widget.task!.task;
    }     
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: (value) =>
          context.read<AddTaskBloc>().add(ChangeTaskValue(value)),
      );
      
  }
}
