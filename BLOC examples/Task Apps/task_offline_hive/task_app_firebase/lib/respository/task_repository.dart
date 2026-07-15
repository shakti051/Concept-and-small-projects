import 'package:task_app_firebase/models/task.dart';

import '../data/local/hive_task_datasource.dart';
import 'firestore_repository.dart';

class TaskRepository {
  final HiveTaskDataSource hive;

  TaskRepository(this.hive);

  Future<void> create(Task task) async {
    await hive.addTask(task);
    //await FirestoreRepository.create(task: task);
  }

  Future<void> update(Task task) async {
    await hive.updateTask(task);
    //await FirestoreRepository.update(task);
  }

  Future<void> delete(Task task) async {
    await hive.deleteTask(task.id);
    // await FirestoreRepository.delete(task: task);
  }

  Future<List<Task>> getAll() async {
    return hive.getAllTasks();
    // return FirestoreRepository.get();
  }

  Future<void> upsertAll(List<Task> tasks) async {
    await hive.upsertAll(tasks);
  }

  Future<void> createRemote(Task task) async {
    await FirestoreRepository.create(task: task);
  }

  Future<void> updateRemote(Task task) async {
    await FirestoreRepository.update(task);
  }

  Future<void> deleteRemote(Task task) async {
    await FirestoreRepository.delete(task: task);
  }

  Future<List<Task>> getRemoteAll() async {
    return FirestoreRepository.get();
  }
}
