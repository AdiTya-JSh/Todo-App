import 'package:flutter/material.dart';
import '/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

      return tasks.isEmpty? Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined,
            size: 80,
            color: Colors.grey,),

            SizedBox(height: 16,),

            Text(
                "No Tasks Yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),),
            
            SizedBox(height: 8,),
            
            Text("Tap + to Add Tasks",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),)
          ],
        ),
      ) :
      ListView.builder(
        itemCount: tasks.length,
      itemBuilder: (context,index){
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),

            child: ListTile(
              onLongPress: (){
                showModalBottomSheet(context: context, builder: (context){
                  return Padding(
                    padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tasks[index].title,
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
                          final controller = TextEditingController(
                            text: tasks[index].title,
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
                                      completed: tasks[index].completed,
                                    ),);
                                  Navigator.pop(context);
                                }, child: const Text("Save"))
                              ],
                            );

                            },
                          );
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text("Delete"),
                        onTap: (){
                          Navigator.pop(context);

                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: const Text("Delete Task"),
                              content: Text.rich(
                                  TextSpan(text: 'Are you sure you want to delete ',

                                  children: [
                                    TextSpan(
                                        text: '"${tasks[index].title}"',
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
                        },
                      )
                    ],
                  ),);
                },);
              },
            leading: IconButton(onPressed: (){
              taskBox.putAt(index, Task(
                  title: tasks[index].title,
                  completed: !tasks[index].completed,),
              );
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


          ),
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
