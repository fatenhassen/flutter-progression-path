// lib/widgets/task_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(String) onDelete;
  final bool isDarkMode;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) => onToggle(task),
          activeColor: Colors.green,
        ),
        title: Text(
          task.text,
          style: TextStyle(
            fontSize: 18,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        subtitle: Text(
          DateFormat('d/M/yyyy, h:mm a').format(task.creationTime),
          style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red.shade400),
          onPressed: () => onDelete(task.id),
        ),
      ),
    );
  }
}