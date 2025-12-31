enum TaskStatus { todo, pending, done }

class Task {
  const Task({required this.taskId, required this.task, required this.status});
  final String taskId;
  final String task;
  final TaskStatus status;
}
