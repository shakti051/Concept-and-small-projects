import 'package:task_app_firebase/models/task.dart';

extension TaskExtension on Task {
  SyncStatus get nextSyncStatus {
    return syncStatus == SyncStatus.pendingCreate
        ? SyncStatus.pendingCreate
        : SyncStatus.pendingUpdate;
  }

  Task get markForHardDelete => copyWith(
    isDeleted: true,
    syncStatus: SyncStatus.pendingHardDelete,
    lastModified: DateTime.now().toUtc(),
  );

  Task get markAsRemoved => copyWith(
    isDeleted: true,
    syncStatus: nextSyncStatus,
    lastModified: DateTime.now().toUtc(),
  );

  Task toggleFavorite() {
    return copyWith(
      isFavorite: !isFavorite,
      syncStatus: nextSyncStatus,
      lastModified: DateTime.now().toUtc(),
    );
  }

  Task get restored {
    return copyWith(
      isDeleted: false,
      isDone: false,
      isFavorite: false,
      date: DateTime.now().toIso8601String(),
      lastModified: DateTime.now().toUtc(),
      syncStatus: nextSyncStatus,
    );
  }
}
