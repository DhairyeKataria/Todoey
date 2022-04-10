import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TaskTile({
    required this.taskTile,
    required this.ischecked,
    required this.checkboxCallback,
    required this.longPressCallback,
  });

  final String taskTile;
  final bool ischecked;
  final Function(bool?) checkboxCallback;
  final Function() longPressCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CheckboxListTile(
        secondary: Text(
          taskTile,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            decoration: ischecked ? TextDecoration.lineThrough : null,
          ),
        ),
        activeColor: Colors.lightBlue,
        value: ischecked,
        onChanged: checkboxCallback,
      ),
      onLongPress: longPressCallback,
    );
  }
}
