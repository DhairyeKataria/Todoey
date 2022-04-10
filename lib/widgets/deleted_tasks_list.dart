import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_tile.dart';
import 'package:todoey/models/task.dart';
import 'package:todoey/data.dart';

class DeletedTasksList extends StatelessWidget {
  const DeletedTasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Deleted Tasks',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300),
          ),
        ),
        Expanded(
          child: Consumer<Data>(
            builder: (context, data, child) => ListView.builder(
              itemBuilder: (context, index) {
                Task task = data.deletedTasks[index];
                return TaskTile(
                  taskTile: task.name,
                  ischecked: task.isDone,
                  checkboxCallback: (value) {
                    data.updateDeletedTask(task, index);
                  },
                  longPressCallback: () {
                    data.deletePermanently(task);
                  },
                );
              },
              itemCount: data.deletedTaskCount,
            ),
          ),
        ),
        Container(height: 80.0)
      ],
    );
  }
}
