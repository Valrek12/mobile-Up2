import 'package:up2_application_mobile/models/task.dart';

class Tasks {
  final List<Task> tasks;
  Tasks({this.tasks});
  factory Tasks.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['tasks'] as List;
    List<Task> tasks =
        tagObjsJson.map((tagJson) => Task.fromJson(tagJson)).toList();
    return Tasks(tasks: tasks);
  }
}

class Items {
  final List<Task> tasks;
  Items({this.tasks});
  factory Items.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['items'] as List;
    List<Task> tasks =
        tagObjsJson.map((tagJson) => Task.fromJson(tagJson)).toList();
    return Items(tasks: tasks);
  }
}
