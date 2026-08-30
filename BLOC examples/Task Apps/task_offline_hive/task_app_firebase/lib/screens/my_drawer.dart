import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_app_firebase/screens/login_screen.dart';

import 'recycle_bin.dart';

import '../blocs/bloc_exports.dart';
import 'tabs_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, this.isRecycleBin = false});

  /// true when this drawer is opened from RecycleBin.
  final bool isRecycleBin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              color: Colors.grey,
              child: Text(
                'Task Drawer',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // ============================================================
            // MY TASKS
            // ============================================================
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.folder_special),
                  title: const Text('My Tasks'),
                  trailing: Text(
                    '${state.pendingTasks.length} | '
                    '${state.completedTasks.length}',
                  ),
                  onTap: () {
                    final tasksBloc = context.read<TasksBloc>();

                    Navigator.of(context).pop();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: tasksBloc,
                          child: const TabsScreen(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const Divider(),

            // ============================================================
            // RECYCLE BIN
            // ============================================================
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Bin'),
                  trailing: Text('${state.removedTasks.length}'),
                  onTap: () {
                    final tasksBloc = context.read<TasksBloc>();

                    Navigator.of(context).pop();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: tasksBloc,
                          child: const RecycleBin(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const Divider(),

            // ============================================================
            // LOGOUT
            // ============================================================
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await GetStorage().remove('token');
                await GetStorage().remove('email');

                if (!context.mounted) {
                  return;
                }

                // Remove all previous routes.
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(LoginScreen.id, (route) => false);
              },
            ),

            // ============================================================
            // THEME SWITCH
            // ============================================================
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Switch(
                  value: state.switchValue,
                  onChanged: (newValue) {
                    if (newValue) {
                      context.read<SwitchBloc>().add(SwitchOnEvent());
                    } else {
                      context.read<SwitchBloc>().add(SwitchOffEvent());
                    }
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
