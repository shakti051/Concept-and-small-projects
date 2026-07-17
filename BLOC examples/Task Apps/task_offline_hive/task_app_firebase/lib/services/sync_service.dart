import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../respository/task_repository.dart';

class SyncService {
  final TaskRepository repository;

  SyncService(this.repository);

  Future<List<Task>> sync(List<Task> localTasks) async {
    var updatedTasks = List<Task>.from(localTasks);

    // 1. Upload new tasks
    updatedTasks = await _syncPendingCreate(updatedTasks);

    // 2. Upload updated tasks
    updatedTasks = await _syncPendingUpdate(updatedTasks);

    // 3. Upload deleted tasks
    updatedTasks = await _syncPendingDelete(updatedTasks);
    debugPrint("===== LOCAL BEFORE MERGE =====");
    for (final t in updatedTasks) {
      debugPrint("${t.title} ${t.syncStatus}");
    }
    // 4. Download everything from Firebase
    final remoteTasks = await repository.getRemoteAll();

    debugPrint("===== REMOTE BEFORE MERGE =====");
    for (final t in remoteTasks) {
      debugPrint("${t.title} ${t.syncStatus}");
    }

    // 5. Merge local and remote
    updatedTasks = _mergeTasks(
      localTasks: updatedTasks,
      remoteTasks: remoteTasks,
    );

    // Save merged result to Hive
    await repository.upsertAll(updatedTasks);

    return updatedTasks;
  }

  //===========================================================
  // CREATE
  //===========================================================

  Future<List<Task>> _syncPendingCreate(List<Task> tasks) async {
    final updatedTasks = List<Task>.from(tasks);

    for (int i = 0; i < updatedTasks.length; i++) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingCreate) {
        continue;
      }

      // Already deleted locally
      if (task.isDeleted) {
        debugPrint("${task.title} skipped because deleted");
        continue;
      }

      try {
        debugPrint("Uploading ${task.title}");

        await repository.createRemote(task);
        debugPrint("Uploaded ${task.title}");

        final syncedTask = task.copyWith(syncStatus: SyncStatus.synced);

        updatedTasks[i] = syncedTask;

        // Update Hive
        await repository.update(syncedTask);
        debugPrint("Saved synced status for ${task.title}");
      } catch (e) {
        debugPrint("Create sync failed (${task.id}): $e");
      }
    }

    return updatedTasks;
  }

  //===========================================================
  // UPDATE
  //===========================================================

  Future<List<Task>> _syncPendingUpdate(List<Task> tasks) async {
    debugPrint("Sync Pending Update Started");

    for (final task in tasks) {
      debugPrint(
        "${task.title} -> ${task.syncStatus} -> deleted=${task.isDeleted}",
      );
    }
    final updatedTasks = List<Task>.from(tasks);

    for (int i = 0; i < updatedTasks.length; i++) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingUpdate) {
        continue;
      }

      try {
        debugPrint("Uploading:");
        debugPrint(task.toMap().toString());

        await repository.updateRemote(task);

        debugPrint("Upload finished");
        final syncedTask = task.copyWith(syncStatus: SyncStatus.synced);

        updatedTasks[i] = syncedTask;

        await repository.update(syncedTask);

        debugPrint("${task.title} updated");
      } catch (e) {
        debugPrint("Update sync failed (${task.id}): $e");
      }
    }

    return updatedTasks;
  }

  //===========================================================
  // DELETE
  //===========================================================

  Future<List<Task>> _syncPendingDelete(List<Task> tasks) async {
    final updatedTasks = List<Task>.from(tasks);

    for (int i = updatedTasks.length - 1; i >= 0; i--) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingHardDelete) {
        continue;
      }

      try {
        await repository.deleteRemote(task);

        await repository.delete(task);

        updatedTasks.removeAt(i);

        debugPrint("${task.title} deleted");
      } catch (e) {
        debugPrint("Delete sync failed (${task.id}): $e");
      }
    }

    return updatedTasks;
  }

  //===========================================================
  // MERGE
  //===========================================================

  List<Task> _mergeTasks({
    required List<Task> localTasks,
    required List<Task> remoteTasks,
  }) {
    final Map<String, Task> merged = {};

    // Add all remote tasks first
    for (final remote in remoteTasks) {
      merged[remote.id] = remote;
    }

    // Decide for every local task
    for (final local in localTasks) {
      final remote = merged[local.id];

      // Remote doesn't exist
      if (remote == null) {
        merged[local.id] = local;
        continue;
      }

      // Local has unsynced changes → local wins
      if (local.syncStatus != SyncStatus.synced) {
        merged[local.id] = local;
      }
      
      // else: keep remote
    }

    return merged.values.toList();
  }
}
