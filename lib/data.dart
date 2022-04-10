import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:todoey/models/task.dart';
import 'package:get_storage/get_storage.dart';

class Data extends ChangeNotifier {
  final List<Task> _tasksList = [];
  final List<Task> _deletedTasksList = [];

  final box = GetStorage(); // Access to the local storage
  List storageList = []; // A list of maps and every map represents single task.

  List storageDeletedList = [];

  // A getter to get an unmodifiable list of tasks.
  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasksList);
  }

  // A getter to get an unmodifiable list of deleted tasks.
  UnmodifiableListView<Task> get deletedTasks {
    return UnmodifiableListView(_deletedTasksList);
  }

  // A getter to get the number of tasks.
  int get taskCount {
    return _tasksList.length;
  }

  // A getter to get the number of deleted tasks.
  int get deletedTaskCount {
    return _deletedTasksList.length;
  }

  void restoreTasks() {
    if (box.read("tasks") != null) {
      storageList = box.read("tasks");

      for (int i = 0; i < storageList.length; i++) {
        final map = storageList[i];

        final task = Task(name: map["nameKey"], isDone: map["isDoneKey"]);
        _tasksList.add(task);
      }
    }
    if (box.read("deleted tasks") != null) {
      storageDeletedList = box.read("deleted tasks");

      for (int i = 0; i < storageDeletedList.length; i++) {
        final map = storageDeletedList[i];

        final task = Task(name: map["nameKey"], isDone: map["isDoneKey"]);
        _deletedTasksList.add(task);
      }
    }
  }

  void addTask(Task? task) {
    _tasksList.add(task!);

    final storageMap = {};

    storageMap["nameKey"] = task.name;
    storageMap["isDoneKey"] = task.isDone;

    storageList.add(storageMap);
    box.write("tasks", storageList);

    notifyListeners();
  }

  void updateTask(Task task, int index) {
    task.toggleState();
    storageList[index]["isDoneKey"] = task.isDone;
    box.write("tasks", storageList);
    notifyListeners();
  }

  void updateDeletedTask(Task task, int index) {
    task.toggleState();
    storageDeletedList[index]["isDoneKey"] = task.isDone;
    box.write("deleted tasks", storageDeletedList);
    notifyListeners();
  }

  void deleteTask(Task task) {
    int? index;
    {
      _deletedTasksList.add(task);

      index = _deletedTasksList.length;
      final storageMap = {};

      storageMap["nameKey"] = task.name;
      storageMap["isDoneKey"] = task.isDone;

      storageDeletedList.add(storageMap);
      box.write("deleted tasks", storageDeletedList);
    }

    index = _tasksList.indexOf(task);
    if (index != -1) {
      _tasksList.remove(task);
      storageList.removeAt(index);

      box.write("tasks", storageList);
    }

    notifyListeners();
  }

  void deletePermanently(Task task) {
    int index = _deletedTasksList.indexOf(task);

    _deletedTasksList.remove(task);
    storageDeletedList.removeAt(index);

    box.write("deleted tasks", storageDeletedList);

    notifyListeners();
  }

  void deleteAllChecked() {
    for (int i = 0; i < _deletedTasksList.length; i++) {
      Task task = _deletedTasksList[i];
      if (task.isDone == true) {
        _deletedTasksList.removeAt(i);
        storageDeletedList.removeAt(i);
      }
    }
    box.write("deleted tasks", storageDeletedList);

    notifyListeners();
  }
}
