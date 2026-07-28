import 'package:task_app_firebase/models/task.dart';

class SyncReport {
  List<Task> tasks;

  int uploaded;
  int updated;
  int deleted;
  int failed;

  SyncReport({
    this.tasks = const [],
    this.uploaded = 0,
    this.updated = 0,
    this.deleted = 0,
    this.failed = 0,
  });

  int get total => uploaded + updated + deleted;

  bool get hasFailures => failed > 0;
}