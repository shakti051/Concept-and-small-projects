
import 'package:flutter/widgets.dart';
import '../models/task.dart';
import '../respository/firestore_repository.dart';
import '../respository/task_repository.dart';

class SyncService {
  final TaskRepository repository;
  SyncService(this.repository);
  Future<List<Task>> syncPendingCreate(List<Task> tasks) async {
    final updatedTasks = List<Task>.from(tasks);

    for (int i = 0; i < updatedTasks.length; i++) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingCreate) {
        continue;
      }

      try {
        await FirestoreRepository.create(task: task);

        updatedTasks[i] = task.copyWith(
          syncStatus: SyncStatus.synced,
        );

        debugPrint("${task.title} synced");
      } catch (e) {
        debugPrint("Sync failed: $e");
      }
    }
    return updatedTasks;
  }
}