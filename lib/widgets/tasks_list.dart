import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_tile.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/data.dart';

class TasksList extends StatelessWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<Data>(
            builder: (context, data, child) => ListView.builder(
              itemBuilder: (context, index) {
                Task task = data.tasks[index];
                return TaskTile(
                  taskTile: task.name,
                  ischecked: task.isDone,
                  checkboxCallback: (value) {
                    data.updateTask(task, index);
                  },
                  longPressCallback: () {
                    data.deleteTask(task);
                  },
                );
              },
              itemCount: data.taskCount,
            ),
          ),
        ),
        Container(height: 80.0)
      ],
    );
  }
}
