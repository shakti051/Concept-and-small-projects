import 'package:hive/hive.dart';
import 'package:task_app_firebase/constants/hive_boxes.dart';
import 'package:task_app_firebase/models/task.dart';

class HiveTaskDataSource {
  static const String taskBox = 'tasks';

 // final Box<Task> _box = Hive.box<Task>(taskBox);
  Box<Task> get _box => Hive.box<Task>(HiveBoxes.tasks);
  Future<void> addTask(Task task) async {}

  Future<void> updateTask(Task task) async {}

  Future<void> deleteTask(String id) async {}

  List<Task> getAllTasks() {
    return [];
  }

  Task? getTask(String id) {
    return null;
  }

  List<Task> getPendingTasks() {
    return [];
  }
}
