import 'package:flutter/foundation.dart';
import '../../models/task.dart';


void logTask({
  required String action,
  required Task task,
}) {
  debugPrint(
    "[$action] "
    "title=${task.title}, "
    "id=${task.id}, "
    "sync=${task.syncStatus.name}, "
    "deleted=${task.isDeleted}, "
    "favorite=${task.isFavorite}, "
    "done=${task.isDone}",
  );
}