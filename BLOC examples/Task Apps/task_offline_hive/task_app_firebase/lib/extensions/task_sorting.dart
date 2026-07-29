import '../models/task.dart';

extension TaskSorting on List<Task> {
  List<Task> sortByLastModified() {
    return [...this]..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }
}
