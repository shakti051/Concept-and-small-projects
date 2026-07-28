// core/mappers/firebase_exception_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../exceptions/app_exceptions.dart';

class FirebaseExceptionMapper {
  static Never throwMapped(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
      case 'unauthenticated':
        throw AuthenticationException();

      case 'unavailable':
      case 'deadline-exceeded':
        throw NetworkException();

      case 'not-found':
        throw FirestoreReadException();

      case 'already-exists':
      case 'aborted':
      case 'failed-precondition':
      default:
        throw FirestoreWriteException();
    }
  }
}