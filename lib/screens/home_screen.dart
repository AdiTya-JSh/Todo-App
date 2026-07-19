import 'package:flutter/material.dart';
import '/models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
    Task(title: "Flutter todo list"),
    Task(title: "Sample Task"),
  ];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void addTask(String title){
    tasks.add(Task(title: title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo App"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
      itemBuilder: (context,index){
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),

            child: ListTile(
            leading: IconButton(onPressed: (){
              setState(() {
                tasks[index].completed = !tasks[index].completed;
              });
            }, icon: Icon(
                tasks[index].completed?
                    Icons.check_box:
                    Icons.check_box_outline_blank,
            ),),

            title: Text(tasks[index].title,
            style: TextStyle(
                decoration: tasks[index].completed? TextDecoration.lineThrough: TextDecoration.none,

            color: tasks[index].completed? Colors.grey:null,
              fontWeight: tasks[index].completed? FontWeight.normal:FontWeight.bold,
            ),),

            trailing: IconButton(onPressed: (){
              setState(() {
                tasks.removeAt(index);
              });
            }, icon: const Icon(Icons.delete)),

          ),
          );
      }),
        
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
                  setState(() {
                    addTask(title);
                  });
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
