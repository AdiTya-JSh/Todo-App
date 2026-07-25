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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin:  EdgeInsets.symmetric(
        horizontal: task.completed? 20 : 12,
        vertical: 10
      ),
      decoration: BoxDecoration(
        color: task.completed?
            Colors.green.shade50:
            Theme.of(context).cardColor,
        
        borderRadius: BorderRadius.circular( task.completed?24 : 16),
        
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
                alpha: task.completed? 0.03 : 0.08),
            blurRadius: task.completed? 2 : 6,
            offset: Offset(0, task.completed? 1 : 2)
          )
        ]
      ),


      child: AnimatedOpacity(opacity: task.completed? 0.75 : 1,
          duration: Duration(milliseconds: 300),
        child:  ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6
        ),
        onLongPress: onLongPress,

        leading: IconButton(
            onPressed: onToggle,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
            transitionBuilder: (child , animation){
                return FadeTransition(opacity: animation, child: ScaleTransition(
                  scale: animation,
                child: child,),
                );
            },
            child:  Icon(task.completed?
            Icons.check_box:
            Icons.check_box_outline_blank,
            color: task.completed? Colors.green : null,
            key: ValueKey(task.completed),
            )
            ),
        ),
        
        title:
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              decoration: task.completed?
              TextDecoration.lineThrough : TextDecoration.none,

              color: task.completed?
              Theme.of(context).disabledColor :
              Theme.of(context).textTheme.bodyLarge?.color,

              fontWeight: task.completed?
              FontWeight.normal
                  : FontWeight.bold,
            ),
            child: Text(task.title),

          )

      ),),
    );
  }
}
