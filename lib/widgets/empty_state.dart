import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_outlined,
            size: 90,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),

          const SizedBox(height: 16,),

          const Text(
            "No Tasks Yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),),

          const SizedBox(height: 8,),

          const Text("Tap + to Add Tasks",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),)
        ],
      ),
    );
  }
}
