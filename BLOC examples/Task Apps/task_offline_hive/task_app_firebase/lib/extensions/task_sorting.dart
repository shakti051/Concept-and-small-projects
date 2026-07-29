import '../models/task.dart';

extension TaskSorting on List<Task> {
  void sortByLastModified() {
    sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }
}
