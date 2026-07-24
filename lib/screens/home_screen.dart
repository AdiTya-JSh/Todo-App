import 'package:flutter/material.dart';
import 'package:todo_app/widgets/empty_state.dart';
import '/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/task_tile.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  late Box<Task> taskBox;

  @override
  void initState(){
    super.initState();

    taskBox = Hive.box<Task>("tasks");
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  void addTask(String title){
    taskBox.add(Task(title: title));
  }


  void showTaskOptions(Task task , int index){
    showModalBottomSheet(context: context, builder: (context){
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit"),
              onTap: (){
                Navigator.pop(context);

                showEditDialog(task, index);

              },
            ),

            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: (){
                Navigator.pop(context);
                showDeleteDialog(task, index);
              },
            )
          ],
        ),);
    },);
  }


  void showEditDialog(Task task , int index){
    final controller = TextEditingController(
      text: task.title,
    );
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),

          TextButton(onPressed: (){
            final title = controller.text.trim();

            if(title.isEmpty)return;
            taskBox.putAt(index,
              Task(
                title : title,
                completed: task.completed,
              ),);
            Navigator.pop(context);
          }, child: const Text("Save"))
        ],
      );

    },
    );
  }


  void showDeleteDialog(Task task , int index){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Delete Task"),
        content: Text.rich(
          TextSpan(text: 'Are you sure you want to delete ',

              children: [
                TextSpan(
                    text: '"${task.title}"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                    )),

                TextSpan(text:' ?'
                ),]
          ),),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Cancel")),

          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red) ,
              onPressed: (){
                taskBox.deleteAt(index);
                Navigator.pop(context);
              }, child: const Text("Delete"))
        ],);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo App"),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, box, child){
          final tasks = box.values.toList();

      return tasks.isEmpty? const EmptyState() :
      ListView.builder(
        itemCount: tasks.length,
      itemBuilder: (context,index){
          return TaskTile(
            task: tasks[index],

            onToggle: (){
              taskBox.putAt(index, Task(
                title: tasks[index].title,
                completed: !tasks[index].completed,
              ));
            },

            onLongPress: (){
              showTaskOptions(tasks[index], index);
            },

          );
      });}),
        
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: const Text("Add Task"),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Enter Task",
                  ),
                ),
              actions: [

                TextButton(onPressed: (){
                  controller.clear();
                  Navigator.pop(context);
                }, child: const Text("Cancel"),),

                TextButton(onPressed: (){
                  final title = controller.text.trim();
                  if(title.isEmpty) return;
                    addTask(title);
                  controller.clear();
                  Navigator.pop(context);
                }, child: const Text("Add"),),
              ],

            );

          },
          );
        },
          child: const Icon(Icons.add),
    ),
    );
  }
}
