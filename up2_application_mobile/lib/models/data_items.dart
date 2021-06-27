import 'package:up2_application_mobile/models/tasks.dart';

class DataItems {
  final Items tasks;

  DataItems({this.tasks});

  factory DataItems.fromJson(Map<String, dynamic> json) {
    return DataItems(tasks: Items.fromJson(json['data']));
  }
}
