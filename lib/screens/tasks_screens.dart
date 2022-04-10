import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/widgets/tasks_list.dart';
import '../widgets/deleted_tasks_list.dart';
import 'add_task_screen.dart';
import 'package:todoey/data.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Data>(context, listen: false).restoreTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: _showDeleted ? const Icon(Icons.delete) : const Icon(Icons.add),
        onPressed: _showDeleted
            ? () {
                Provider.of<Data>(context, listen: false).deleteAllChecked();
              }
            : () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: (context),
                  builder: (context) => const AddTaskScreen(),
                );
              },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, top: 60.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.list,
                      size: 30.0,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _showDeleted = !_showDeleted;
                    });
                  },
                ),
                const Text(
                  'Todoey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Consumer<Data>(
                  builder: (BuildContext context, data, child) => Text(
                    _showDeleted
                        ? data.deletedTaskCount.toString() + " Deleted Tasks"
                        : data.taskCount.toString() + " Tasks",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child:
                  _showDeleted ? const DeletedTasksList() : const TasksList(),
            ),
          ),
        ],
      ),
    );
  }
}
