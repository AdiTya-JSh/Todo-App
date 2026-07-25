import 'package:flutter/material.dart';
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
  List<Task> tasks = [];

  @override
  void initState(){
    super.initState();

    taskBox = Hive.box<Task>("tasks");
    tasks = taskBox.values.toList();
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  void addTask(String title){
    final task = Task(title: title);

    tasks.add(task);
    taskBox.add(task);

    setState(() {});
  }

  void showMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),)
    );
  }

  void submitTask(String title){
    title = title.trim();
    if(title.isEmpty) return;
    Navigator.pop(context);
    addTask(title);
    showMessage("Task Added");
  }

  void showAddDialog(){
    controller.clear();
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter Task",
          ),
          onSubmitted: submitTask
        ),
        actions: [

          TextButton(onPressed: (){

            Navigator.pop(context);
          }, child: const Text("Cancel"),),

          FilledButton(onPressed: () => submitTask(controller.text),
            child: const Text("Add"),),
        ],

      );

    },
    );
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
            final updatedTask = Task(
              title : title,
              completed: task.completed,);

            tasks[index] = updatedTask;
            taskBox.putAt(index, updatedTask);

            setState(() {});
            Navigator.pop(context);
            showMessage("Task Updated");
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
                final deletedTask = tasks.removeAt(index);
                taskBox.deleteAt(index);
                setState(() {});
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                final showSnack = messenger.showSnackBar(
                    SnackBar(
                      content: const Text("Task Deleted"),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    action: SnackBarAction(

                        label: "UNDO", onPressed: (){
                          tasks.add(deletedTask);
                      taskBox.add(deletedTask);
                      setState(() {});
                     }),
      )
                );
                Future.delayed(const Duration(seconds: 4),(){
                  showSnack.close();
                });
              }, child: const Text("Delete"))
        ],);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Tasks"),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(24),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("${tasks.length} ${tasks.length==1?"Task" : "Tasks"}"),
                  )
      ),),
      body: tasks.isEmpty? const EmptyState() :
      ListView.builder(
        itemCount: tasks.length,
      itemBuilder: (context,index){
          return TaskTile(
            task: tasks[index],

            onToggle: (){
              final updatedTask = Task(
                title: tasks[index].title,
                completed: !tasks[index].completed,
              );
              tasks[index] = updatedTask;
              taskBox.putAt(index, updatedTask);

              setState(() {});
            },

            onLongPress: (){
              showTaskOptions(tasks[index], index);
            },

          );
      }),

        floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddDialog,
          icon: const Icon(Icons.add),
          label: const Text("Add Task"),
    ),
    );
  }
}
