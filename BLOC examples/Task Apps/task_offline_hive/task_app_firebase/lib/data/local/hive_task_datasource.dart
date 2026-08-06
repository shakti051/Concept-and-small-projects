import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/extensions/task_sorting.dart';
import 'package:task_app_firebase/models/task.dart';

import '../../core/exceptions/app_exceptions.dart';

class HiveTaskDataSource {
  final String email;

  HiveTaskDataSource(this.email);

  String get _boxName => HiveBoxes.tasks(email);

  Box<Task> get _box => Hive.box<Task>(_boxName);

  Future<void> addTask(Task task) async {
    try {
      await _box.put(task.id, task);
    } catch (_) {
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
    final tasks = _box.values.toList();
    tasks.sortByLastModified();
    return tasks;
  }

  Future<void> upsertAll(List<Task> tasks) async {
    await _box.putAll({for (final task in tasks) task.id: task});
  }

  Future<void> createAll(List<Task> tasks) async {
    await _box.putAll({for (final task in tasks) task.id: task});
  }

  Future<void> updateAll(List<Task> tasks) async {
    await _box.putAll({for (final task in tasks) task.id: task});
  }

  Future<void> deleteAll(List<Task> tasks) async {
    await _box.deleteAll(tasks.map((e) => e.id).toList());
  }
}
