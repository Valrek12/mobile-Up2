import 'package:flutter/material.dart';
import 'package:up2_application_mobile/models/task.dart';

class TablePageTask extends StatefulWidget {
  final Task tasks;

  const TablePageTask({Key key, this.tasks}) : super(key: key);
  TablePageTaskState createState() => TablePageTaskState();
}

Widget taskTable(Task task) {
  return Table(
    border: TableBorder.all(),
    children: [
      TableRow(children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[0]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[1]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[2]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[3]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[4]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[5]))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: Text(task.weekWriteOffTimes[6]))),
      ])
    ],
  );
}

class TablePageTaskState extends State<TablePageTask> {
  @override
  Widget build(BuildContext context) {
    return taskTable(widget.tasks);
  }
}
