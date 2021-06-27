import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up2_application_mobile/bloc/task/task_event.dart';
import 'package:up2_application_mobile/bloc/task/task_state.dart';
import 'package:up2_application_mobile/models/data_items.dart';
import 'package:up2_application_mobile/service/up2_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Up2Repository up2repository;

  final String password;
  final String task;
  final String login;

  TaskBloc(
      {@required this.password,
      @required this.login,
      @required this.up2repository,
      @required this.task})
      : assert(up2repository != null),
        super(TaskEmptyState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is TaskLoadEvent) {
      yield TaskLoadingState();
      try {
        final DataItems _loadTaskList =
            await up2repository.getBusiness(task, login, password);
        yield TaskLoadedState(loadTask: _loadTaskList);
      } catch (_) {
        yield TaskErrorState();
      }
    }
  }
}
