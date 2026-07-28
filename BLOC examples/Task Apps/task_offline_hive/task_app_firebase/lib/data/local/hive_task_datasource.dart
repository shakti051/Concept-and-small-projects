import 'package:hive/hive.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/models/task.dart';

import '../../core/exceptions/app_exceptions.dart';

class HiveTaskDataSource {
  static const String taskBox = 'tasks';

  // final Box<Task> _box = Hive.box<Task>(taskBox);
  Box<Task> get _box => Hive.box<Task>(HiveBoxes.tasks);
  Future<void> addTask(Task task) async {
    try {
      await _box.put(task.id, task);
    } catch (_)  {
      throw LocalDatabaseException();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _box.put(task.id, task);
    } catch (_) {
      throw LocalDatabaseException();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _box.delete(id);
    } catch (_) {
      throw LocalDatabaseException();
    }
  }

  List<Task> getAllTasks() {
    return _box.values.toList();
  }

  Future<void> upsertAll(List<Task> tasks) async {
    final Map<String, Task> map = {for (final task in tasks) task.id: task};

    await _box.putAll(map);
  }
}
