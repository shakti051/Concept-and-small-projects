import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../widgets/tasks_list.dart';

class PendingTasksScreen extends StatelessWidget {
  const PendingTasksScreen({super.key});
  static const id = 'tasks_screen';
    @override
Widget build(BuildContext context) {
  final bloc = context.read<TasksBloc>();

  debugPrint(
    "===== PENDING SCREEN BLOC ===== ${identityHashCode(bloc)}",
  );

  return BlocBuilder<TasksBloc, TasksState>(
    builder: (context, state) {
      debugPrint(
        "===== PENDING SCREEN BUILD ===== "
        "bloc=${identityHashCode(context.read<TasksBloc>())} "
        "pending=${state.pendingTasks.length}",
      );

      final tasksList = state.pendingTasks;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
            ElevatedButton(
              onPressed: () async {
                await Workmanager().registerOneOffTask(
                  DateTime.now().millisecondsSinceEpoch.toString(),
                  "backgroundSync",
                  constraints: Constraints(
                    networkType: NetworkType.connected,
                  ),
                );

                debugPrint("Worker Registered");
              },
              child: const Text("Run Worker"),
            ),
          const SizedBox(height: 8),
          Center(
            child: Chip(
              label: Text(
                '${tasksList.length} Pending | '
                '${state.completedTasks.length} Completed',
              ),
            ),
          ),
          TasksList(tasksList: tasksList),
        ],
      );
    },
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<TasksBloc, TasksState>(
  //     builder: (context, state) {
  //       List<Task> tasksList = state.pendingTasks;
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
  //             ElevatedButton(
  //               onPressed: () async {
  //                 await Workmanager().registerOneOffTask(
  //                   DateTime.now().millisecondsSinceEpoch.toString(),
  //                   "backgroundSync",
  //                   constraints: Constraints(
  //                     networkType: NetworkType.connected,
  //                   ),
  //                 );
  //                 debugPrint("Worker Registered");
  //               },
  //               child: const Text("Run Worker"),
  //             ),
  //           SizedBox(height: 8),
  //           Center(
  //             child: Chip(
  //               label: Text(
  //                 '${tasksList.length} Pending | ${state.completedTasks.length} Completed',
  //               ),
  //             ),
  //           ),
  //           TasksList(tasksList: tasksList),
  //         ],
  //       );
  //     },
  //   );
  // }
}
