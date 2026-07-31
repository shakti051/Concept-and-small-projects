import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/mappers/firebase_exception_mapper.dart';
import '../models/task.dart';

class FirestoreRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String? testUserEmail;

  static String get _userCollection {
    final email = testUserEmail ?? GetStorage().read("email");

    if (email == null || email.isEmpty) {
      throw Exception("No logged in user.");
    }

    return email;
  }

  static Future<void> create({Task? task}) async {
    try {
      await firestore
          .collection(_userCollection)
          .doc(task!.id)
          .set(task.toFirestoreMap());
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  static Future<List<Task>> get() async {
    try {
      final data = await firestore.collection(_userCollection).get();

      return data.docs.map((doc) => Task.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  static Future<void> update(Task? task) async {
    try {
      await firestore
          .collection(_userCollection)
          .doc(task!.id)
          .update(task.toFirestoreMap());
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  static Future<void> delete({Task? task}) async {
    try {
      await firestore.collection(_userCollection).doc(task!.id).delete();
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }

  static Future<void> deleteAllRemovedTask({List<Task>? taskList}) async {
    try {
      final batch = firestore.batch();

      final collection = firestore.collection(_userCollection);

      for (final task in taskList ?? []) {
        batch.delete(collection.doc(task.id));
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseExceptionMapper.throwMapped(e);
    }
  }
}
