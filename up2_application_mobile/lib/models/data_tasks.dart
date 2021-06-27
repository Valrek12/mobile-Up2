import 'package:up2_application_mobile/models/tasks.dart';

class DataTasks {
  final Tasks tasks;

  DataTasks({this.tasks});

  factory DataTasks.fromJson(Map<String, dynamic> json) {
    return DataTasks(tasks: Tasks.fromJson(json['data']));
  }
}
