import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onLongPress;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onLongPress,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16
      ),


      child: ListTile(
        onLongPress: onLongPress,

        leading: IconButton(
            onPressed: onToggle,
            icon: Icon(task.completed?
            Icons.check_box:
            Icons.check_box_outline_blank)),
        
        title: Text(
            task.title,
        style: TextStyle(
          decoration: task.completed?
              TextDecoration.lineThrough : TextDecoration.none,

          color: task.completed?
              Colors.grey:null,

          fontWeight: task.completed?
              FontWeight.normal
              : FontWeight.bold,
        ),),

      ),
    );
  }
}
