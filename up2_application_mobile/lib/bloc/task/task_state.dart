import 'package:flutter/cupertino.dart';
import 'package:up2_application_mobile/models/data_items.dart';

abstract class TaskState {}

class TaskEmptyState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  DataItems loadTask;
  TaskLoadedState({@required this.loadTask}) : assert(loadTask != null);
}

class TaskErrorState extends TaskState {}
