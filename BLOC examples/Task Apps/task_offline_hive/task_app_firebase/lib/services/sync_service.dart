import 'package:flutter/foundation.dart';
import '../core/exceptions/app_exceptions.dart';
import '../models/sync_report.dart';
import '../models/task.dart';
import '../respository/task_repository.dart';

class SyncService {
  final TaskRepository repository;

  SyncService(this.repository);

  Future<SyncReport> sync(List<Task> localTasks) async {
    try {
      final report = SyncReport();

      var updatedTasks = List<Task>.from(localTasks);

      // CREATE
      updatedTasks = await _syncPendingCreate(updatedTasks, report);

      // UPDATE
      updatedTasks = await _syncPendingUpdate(updatedTasks, report);

      // DELETE
      updatedTasks = await _syncPendingDelete(updatedTasks, report);

      debugPrint("===== LOCAL BEFORE MERGE =====");
      for (final task in updatedTasks) {
        debugPrint("${task.title} ${task.syncStatus}");
      }

      final remoteTasks = await repository.getRemoteAll();

      debugPrint("===== REMOTE BEFORE MERGE =====");
      for (final task in remoteTasks) {
        debugPrint("${task.title} ${task.syncStatus}");
      }

      updatedTasks = _mergeTasks(
        localTasks: updatedTasks,
        remoteTasks: remoteTasks,
      );

      await repository.upsertAll(updatedTasks);

      report.tasks = updatedTasks;

      return report;
    } on AuthenticationException {
      rethrow;
    }
  }

  //===========================================================
  // CREATE
  //===========================================================

  Future<List<Task>> _syncPendingCreate(
    List<Task> tasks,
    SyncReport report,
  ) async {
    final updatedTasks = List<Task>.from(tasks);

    for (int i = 0; i < updatedTasks.length; i++) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingCreate) {
        continue;
      }

      // Skip if already deleted locally
      if (task.isDeleted) {
        debugPrint("${task.title} skipped because deleted");
        continue;
      }

      try {
        debugPrint("Uploading ${task.title}");

        await repository.createRemote(task);

        final syncedTask = task.copyWith(syncStatus: SyncStatus.synced);

        updatedTasks[i] = syncedTask;

        // Update Hive
        await repository.update(syncedTask);

        report.uploaded++;

        debugPrint("${task.title} uploaded successfully");
      } on NetworkException {
        report.failed++;
        debugPrint("No internet while syncing ${task.title}");
        continue;
      } on FirestoreWriteException {
        report.failed++;
        debugPrint("Firestore write failed for ${task.title}");
        continue;
      } on AuthenticationException {
        debugPrint("Authentication failed");
        rethrow;
      } catch (e) {
        report.failed++;
        debugPrint("Unexpected error while uploading ${task.title}: $e");
        continue;
      }
    }

    return updatedTasks;
  }

  //===========================================================
  // UPDATE
  //===========================================================

  Future<List<Task>> _syncPendingUpdate(
    List<Task> tasks,
    SyncReport report,
  ) async {
    debugPrint("===== Sync Pending Update Started =====");

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
        debugPrint("Updating ${task.title}");

        await repository.updateRemote(task);

        final syncedTask = task.copyWith(syncStatus: SyncStatus.synced);

        updatedTasks[i] = syncedTask;

        // Update local Hive
        await repository.update(syncedTask);

        report.updated++;

        debugPrint("${task.title} updated successfully");
      } on NetworkException {
        report.failed++;
        debugPrint("No internet while updating ${task.title}");
        continue;
      } on FirestoreWriteException {
        report.failed++;
        debugPrint("Firestore update failed for ${task.title}");
        continue;
      } on AuthenticationException {
        debugPrint("Authentication failed");
        rethrow;
      } catch (e) {
        report.failed++;
        debugPrint("Unexpected error while updating ${task.title}: $e");
        continue;
      }
    }

    return updatedTasks;
  }

  //===========================================================
  // DELETE
  //===========================================================

  Future<List<Task>> _syncPendingDelete(
    List<Task> tasks,
    SyncReport report,
  ) async {
    final updatedTasks = List<Task>.from(tasks);

    for (int i = updatedTasks.length - 1; i >= 0; i--) {
      final task = updatedTasks[i];

      if (task.syncStatus != SyncStatus.pendingHardDelete) {
        continue;
      }

      try {
        debugPrint("Deleting ${task.title}");

        // Delete from Firestore
        await repository.deleteRemote(task);

        // Delete from Hive
        await repository.delete(task);

        // Remove from local list
        updatedTasks.removeAt(i);

        report.deleted++;

        debugPrint("${task.title} deleted successfully");
      } on NetworkException {
        report.failed++;
        debugPrint("No internet while deleting ${task.title}");
        continue;
      } on FirestoreWriteException {
        report.failed++;
        debugPrint("Firestore delete failed for ${task.title}");
        continue;
      } on AuthenticationException {
        debugPrint("Authentication failed");
        rethrow;
      } catch (e) {
        report.failed++;
        debugPrint("Unexpected error while deleting ${task.title}: $e");
        continue;
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
