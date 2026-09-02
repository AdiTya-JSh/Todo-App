import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  bool completed;

  @HiveField(3)
  int order;

  @HiveField(0)
  String id;

  Task({
    String? id,
    required this.title,
    this.completed = false,
    required this.order,
}):id = id?? const Uuid().v4();
}

