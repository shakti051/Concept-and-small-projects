import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app1/blocs/blocs.dart';
import 'package:task_app1/screens/recycle_bin.dart';
import 'package:task_app1/screens/tabs_screen.dart';
import 'package:task_app1/screens/pending_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  //   const MyDrawer({super.key});

  //   @override
  //   State<MyDrawer> createState() => _MyDrawerState();
  // }

  // class _MyDrawerState extends State<MyDrawer> {
  //  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              color: Colors.grey,
              child: Text(
                "Task Drawer",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(TabsScreen.id);
                  },
                  child: ListTile(
                    leading: Icon(Icons.folder_special),
                    title: Text("My Task"),
                    trailing: Text("${state.pendingTask.length}/${state.completedTask.length}"),
                  ),
                );
              },
            ),
            Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(RecycleBin.id);
                  },
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Bin"),
                    trailing: Text("${state.removeTask.length}"),
                  ),
                );
              },
            ),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Switch(
                  value: state.switchValue,
                  onChanged: (newValue) {
                    print(newValue);
                    newValue
                        ? context.read<SwitchBloc>().add(SwitchOnEvent())
                        : context.read<SwitchBloc>().add(SwitchOffEvent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
