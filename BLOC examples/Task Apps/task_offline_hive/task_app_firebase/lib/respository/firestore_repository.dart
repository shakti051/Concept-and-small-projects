import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/mappers/firebase_exception_mapper.dart';
import '../models/task.dart';

class FirestoreRepository {
  static String get _userCollection {
    final email = GetStorage().read("email");

    if (email == null || email.isEmpty) {
      throw Exception("No logged in user.");
    }

    return email;
  }

  //create task
  static Future<void> create({Task? task}) async {
    try {
      await FirebaseFirestore.instance
          .collection(_userCollection)
          .doc(task!.id)
          .set(task.toFirestoreMap());
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  // get task

  static Future<List<Task>> get() async {
    List<Task> taskList = [];

    try {
      final email = GetStorage().read("email");

      if (email == null || email.isEmpty) {
        debugPrint("User not logged in. Skip Firestore fetch.");
        return [];
      }

      final data = await FirebaseFirestore.instance
          .collection(_userCollection)
          .get();

      for (var task in data.docs) {
        taskList.add(Task.fromMap(task.data()));
      }

      return taskList;
    } catch (e, stack) {
      debugPrint("Firestore get error: $e");
      debugPrint(stack.toString());
      throw Exception(e.toString());
    }
  }

  //Update task
  static Future<void> update(Task? task) async {
    try {
      final data = FirebaseFirestore.instance.collection(_userCollection);
      await data.doc(task!.id).update(task.toFirestoreMap());
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  //Delete task
  static Future<void> delete({Task? task}) async {
    try {
      debugPrint("Deleting document: ${task!.id}");
      final data = FirebaseFirestore.instance.collection(_userCollection);
      await data.doc(task.id).delete();
      debugPrint("Delete successful");
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  //Delete All task
  static Future<void> deleteAllRemovedTask({List<Task>? taskList}) async {
    try {
      final data = FirebaseFirestore.instance.collection(_userCollection);
      for (var task in taskList!) {
        data.doc(task.id).delete();
      }
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }
}
