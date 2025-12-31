import 'dart:async';
import 'package:flutter/material.dart';
import '../task_repository.dart';
import 'enums/category.dart';

class TaskRepository {
  //all the methods related to tasks
  //adding tasks
  //editing tasks
  //deleting tasks

  //bloc doesn't communicate with apis or local databases
  //bloc communicate with repos
  //repos comunicate with apis and local databases

  //streamcontroller for the list of todos
  final _controller = StreamController<List<Task>>.broadcast();

  //list of tasks
  List<Task> _tasks = [];

  //getter for the tasks list
  Stream<List<Task>> get allTodos async* {
    yield* _controller.stream;
  }

  //adding task
  void addTask(Task newTask) {
    _tasks.add(newTask);
    _controller.add(_tasks);
  }

  void editTask(Task task) {
    List<Task> newList = [];
    for (Task todo in _tasks) {
      if (todo.taskId == task.taskId) {
        newList.add(task);
      } else {
        newList.add(todo);
      }
    }

    print(_tasks.length);

    _tasks = newList;
    _controller.add(_tasks);
  }

  void deleteTask(String id) {
    List<Task> newList = [];
    for (var todo in _tasks) {
      if (todo.taskId != id) {
        newList.add(todo);
      }
    }
    _tasks = newList;
    _controller.add(_tasks);
  }

  Color getColorForCategory(TaskCategory category) {
    switch (category) {
      case TaskCategory.all:
        return Colors.pinkAccent;
      case TaskCategory.done:
        return Colors.green;
      case TaskCategory.pending:
        return Colors.orange;
      case TaskCategory.todo:
        return Colors.redAccent;
    }
  }

  Color getColorForTaskStatus(TaskStatus category) {
    switch (category) {
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.todo:
        return Colors.redAccent;
    }
  }

  String getTextForTaskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'todo';
      case TaskStatus.done:
        return 'done';
      case TaskStatus.pending:
        return 'pending';
    }
  }

  String getTextForCategory(TaskCategory category, int amount) {
    switch (category) {
      case TaskCategory.all:
        return '$amount';
      case TaskCategory.done:
        return '$amount done';
      case TaskCategory.pending:
        return '$amount pending';
      case TaskCategory.todo:
        return '$amount todos';
    }
  }

  int getLengthOfTasksForCategory(TaskCategory cat, List<Task> list) {
    int length = 0;
    if (cat == TaskCategory.all) {
      length = list.length;
    } else if (cat == TaskCategory.done) {
      var newList = [];
      for (var el in list) {
        if (el.status == TaskStatus.done) {
          newList.add(el);
        }
      }
      length = newList.length;
    } else if (cat == TaskCategory.pending) {
      var newList = [];
      for (var el in list) {
        if (el.status == TaskStatus.pending) {
          newList.add(el);
        }
      }
      length = newList.length;
    } else if (cat == TaskCategory.todo) {
      var newList = [];
      for (var el in list) {
        if (el.status == TaskStatus.todo) {
          newList.add(el);
        }
      }
      length = newList.length;
    }
    return length;
  }
}
