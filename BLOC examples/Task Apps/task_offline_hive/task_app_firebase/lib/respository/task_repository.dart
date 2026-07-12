import 'package:task_app_firebase/models/task.dart';

import 'firestore_repository.dart';

class TaskRepository {
  Future<void> create(Task task) async {
    await FirestoreRepository.create(task: task);
  }

  Future<void> update(Task task) async {
    await FirestoreRepository.update(task);
  }

  Future<void> delete(Task task) async {
    await FirestoreRepository.delete(task: task);
  }

  Future<List<Task>> getAll() async {
    return FirestoreRepository.get();
  }
}